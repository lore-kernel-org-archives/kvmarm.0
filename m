Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC11628030F;
	Wed, 14 May 2025 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747244271; cv=none; b=qmMICJGTTcoOBhVs3wgfdmQ/F+bw7HfvPxauWt1KB6vNMs/lgYAdw9UjxOBS9f3hGRBfcm+JdVjZpIIndZ3aEwKUCXRdD6O7BlriCS6Y1GP6zJZ6DSGmhAvZmk/QjFBAuYR2pdMZiGQhtw534jVe8/E00Yx9j6rGnnee+XV4fUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747244271; c=relaxed/simple;
	bh=+VHl0UK3d8GEjmS3sxrSSCAbinnVVe6jnciKJn6o5zs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fXrmjD8ttoI+BLS5uDOzxnahieoDzwMsUJeAzfpIQMAeOQnjoQZCuAr6GjS9fw8UJkVFltHpXlbida9w7apBs0kibeNuZwbn5jy8RsQcHvz77hlOyJJdx7fJbYiKDDnF3wbp49g3u+2jRoO2ZwcFbBpsHGtrOzDrasRjIL2jMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B571C4CEED;
	Wed, 14 May 2025 17:37:48 +0000 (UTC)
Date: Wed, 14 May 2025 13:38:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/24] Tracefs support for pKVM
Message-ID: <20250514133815.78bc2599@gandalf.local.home>
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue,  6 May 2025 17:47:56 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> The growing set of features supported by the hypervisor in protected
> mode necessitates debugging and profiling tools. Tracefs is the
> ideal candidate for this task:
>=20
>   * It is simple to use and to script.
>=20
>   * It is supported by various tools, from the trace-cmd CLI to the
>     Android web-based perfetto.
>=20
>   * The ring-buffer, where are stored trace events consists of linked
>     pages, making it an ideal structure for sharing between kernel and
>     hypervisor.
>=20
> This series first introduces a new generic way of creating remote events =
and
> remote buffers. Then it adds support to the pKVM hypervisor.
>=20
> 1. ring-buffer
> --------------
>=20
> To setup the per-cpu ring-buffers, a new interface is created:
>=20
>   ring_buffer_remote:	Describes what the kernel needs to know about the
> 			remote writer, that is, the set of pages forming the
> 			ring-buffer and a callback for the reader/head
> 			swapping (enables consuming read)
>=20
>   ring_buffer_remote():	Creates a read-only ring-buffer from a
> 			ring_buffer_remote.
>=20
> To keep the internals of `struct ring_buffer` in sync with the remote,
> the meta-page is used. It was originally introduced to enable user-space
> mapping of the ring-buffer [1]. In this case, the kernel is not the
> producer anymore but the reader. The function to read that meta-page is:
>=20
>   ring_buffer_poll_remote():
> 			Update `struct ring_buffer` based on the remote
> 			meta-page. Wake-up readers if necessary.
>=20
> The kernel has to poll the meta-page to be notified of newly written
> events.
>=20
> 2. Tracefs
> ----------
>=20
> This series introduce a new trace_remote that does the link between
> tracefs and the remote ring-buffer.
>=20
> The interface is found in the remotes/ directory at the root of the
> tracefs mount point. Each remote is like an instance and you'll find
> there a subset of the regular Tracefs user-space interface:
>=20
>   remotes/test/
>      buffer_size_kb
>      trace_clock
>      trace_pipe
>      trace
>      per_cpu/
>              cpuX/
>                  trace
>                  trace_pipe
>      events/
>=20
>             test/
>                 selftest/
>                           enable
>                           id
>=20
> Behind the scenes, kernel/trace/trace_remote.c creates this tracefs
> hierarchy without relying on kernel/trace/trace.c. This is due to
> fundamental differences:
>=20
>   * Remote tracing doesn't support trace_array's system-specific
>     features (snapshots, tracers, etc.).
>=20
>   * Logged event formats differ (e.g., no PID for remote events).
>=20
>   * Buffer operations require specific remote interactions.
>=20
> 3. Simple Ring-Buffer
> ---------------------
>=20
> As the current ring-buffer.c implementation has too many dependencies to
> be used directly by the pKVM hypervisor. A new simple implementation is
> created and can be found in kernel/trace/simple-ring-buffer.c.
>=20
> This implementation is write-only and is used by both the pKVM
> hypervisor and a trace_remote test module.
>=20
> 4. Events
> ---------
>=20
> A new REMOTE_EVENT() macro is added to simplify the creation of events
> on the kernel side. As remote tracing buffer are read only, only the
> event structure and a way of printing must be declared. The prototype of
> the macro is very similar to the well-known TRACE_EVENT()
>=20
>  REMOTE_EVENT(my_event, id,
>      RE_STRUCT(
>          re_field(u64, foobar)
>      ),
>      RE_PRINTK("foobar=3D%lld", __entry->foobar)
>      )
>   )
>=20
> 5. pKVM
> -------
>=20
> The pKVM support simply creates a "hypervisor" trace_remote on the
> kernel side and inherits from simple-ring-buffer.c on the hypervisor
> side.
>=20
> A new event macro is created HYP_EVENT() that is under the hood re-using
> REMOTE_EVENT() (defined in the previous paragaph) as well as generate
> hypervisor specific struct and trace_<event>() functions.
>=20
> 5. Limitations:
> ---------------
>=20
> Non-consuming reading of the buffer isn't supported (i.e. cat trace ->
> -EPERM) due to current the lack of support in the ring-buffer meta-page.
>=20
> [1] https://tracingsummit.org/ts/2022/hypervisortracing/
> [2] https://lore.kernel.org/all/20240510140435.3550353-1-vdonnefort@googl=
e.com/
>=20

BTW,  I tried to build this series and it fails.

  CALL    /work/git/test-linux.git/scripts/checksyscalls.sh
  CC      kernel/trace/simple_ring_buffer.o
In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                 from /work/git/test-linux.git/include/linux/compiler.h:390,
                 from /work/git/test-linux.git/arch/x86/include/asm/atomic.=
h:5,
                 from /work/git/test-linux.git/include/linux/atomic.h:7,
                 from /work/git/test-linux.git/kernel/trace/simple_ring_buf=
fer.c:7:
/work/git/test-linux.git/kernel/trace/simple_ring_buffer.c: In function =E2=
=80=98simple_rb_move_tail=E2=80=99:
/work/git/test-linux.git/include/asm-generic/rwonce.h:55:37: error: assignm=
ent to =E2=80=98struct list_head *=E2=80=99 from =E2=80=98long unsigned int=
=E2=80=99 makes pointer from integer without a cast [-Wint-conversion]
   55 |         *(volatile typeof(x) *)&(x) =3D (val);                     =
       \
      |                                     ^
/work/git/test-linux.git/include/asm-generic/rwonce.h:61:9: note: in expans=
ion of macro =E2=80=98__WRITE_ONCE=E2=80=99
   61 |         __WRITE_ONCE(x, val);                                      =
     \
      |         ^~~~~~~~~~~~
/work/git/test-linux.git/arch/x86/include/asm/barrier.h:63:9: note: in expa=
nsion of macro =E2=80=98WRITE_ONCE=E2=80=99
   63 |         WRITE_ONCE(*p, v);                                         =
     \
      |         ^~~~~~~~~~
/work/git/test-linux.git/include/asm-generic/barrier.h:172:55: note: in exp=
ansion of macro =E2=80=98__smp_store_release=E2=80=99
  172 | #define smp_store_release(p, v) do { kcsan_release(); __smp_store_r=
elease(p, v); } while (0)
      |                                                       ^~~~~~~~~~~~~=
~~~~~~
/work/git/test-linux.git/kernel/trace/simple_ring_buffer.c:129:17: note: in=
 expansion of macro =E2=80=98smp_store_release=E2=80=99
  129 |                 smp_store_release(&new_tail->list.next,
      |                 ^~~~~~~~~~~~~~~~~
make[5]: *** [/work/git/test-linux.git/scripts/Makefile.build:203: kernel/t=
race/simple_ring_buffer.o] Error 1
make[4]: *** [/work/git/test-linux.git/scripts/Makefile.build:461: kernel/t=
race] Error 2
make[3]: *** [/work/git/test-linux.git/scripts/Makefile.build:461: kernel] =
Error 2
make[2]: *** [/work/git/test-linux.git/Makefile:2004: .] Error 2
make[1]: *** [/work/git/test-linux.git/Makefile:248: __sub-make] Error 2
make[1]: Leaving directory '/work/build/trace/nobackup/debiantesting-x86-64'

Even when I fixed this, it then failed with the building of the sample modu=
le.

I think you need something like:

obj-$(CONFIG_TRACE_REMOTE_TEST) +=3D remote_test_mod.o

remote_test_mod-y :=3D simple_ring_buffer.o remote_test.o trace_remote.o

If the module needs more than one object file. Then the module should be
called something that doesn't have a .c file and use that name with ".o" to
add all the objects.

I think this could work, but this still had issues with functions not expor=
ted.

-- Steve
