Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2429946F
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 23:43:20 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3f191c1a8a7so798275e9.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682034199; x=1684626199;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fhzUGQ0e3jau16rJuaHw7YFz5UmtipEFtsxsVMwlu4=;
        b=UYbLnr16QO4IB0We1VDV539qc+2tWQPauIHMDaQKLDm3M0JNbW99SLR4W9GXxtH4jm
         k6cYUWmZH1WidXx+/XFkpAVTsXEcES9YXeHfx3nUXtl27yMbAeoWRQ6Zg93RfliU7FEs
         6IKPfasPD+g+2NA4qadYnhpUivC2Xwm6KoN6PQGN/4sgNwlLWNZpKkeotpLTkGFn5Ke8
         uUXmbSFLTLEqbwTZt5xt5GdY7wtv4cQpQh446jkBdj6igKPXbGe/00am6xgnSgUq971r
         Mynkjsdpv5PgYjDlO3ar/0U/TdV8AvnIAltXoVv8m1fIFHl+jlgMmbZEr5kc8pbQZu1T
         17pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682034199; x=1684626199;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fhzUGQ0e3jau16rJuaHw7YFz5UmtipEFtsxsVMwlu4=;
        b=GqVrzkWZNVzm3NySZd58Tf23hAfrKW6zWK/f1O6kRQ7zLyIFmabMqxCe1OIcSQbPP1
         Xc0iBdBCP8DnKSQhIyGqFoFbHgHFQzH90p0FTzKQ0X8OzrUy5GQkbx30VhUTnCgsJitc
         4jvKWRy8uOfbOBWV52BRra+6UOYjOAhZZhHBb2GVVV4wwssKpLDihJA4ZF778klUSWe0
         nNWU9pW22e2N5aOpv+ym28VdPbujTz824A7C3M49/uaMFYlZcxkJ0apV1LAwaG6XYSjN
         zTEM2D5Pr3vOUIfd5RPSMkWxX5S013KGSZWqLeJSrjpAMHwuDyFuonRADag/Q18nHBNq
         cOpA==
X-Gm-Message-State: AAQBX9ebc1tKIyXc3gkIw5pqlmC0Yj5GpIIvHJ6UBAaU9sSg9G5G0aRz
	NoJIy0SKmq0dB4DSpQF2Tij3DKMjgjgnzCf/TuiKvw==
X-Google-Smtp-Source: AKy350Yc1v1rg4zYV+FiSYexap1BoXIvqOLIjo0EMWVhVfh2m/JOxLdOw+yuxlGGAyVt/JPqC+clOdtqOo/BZV0O4QE=
X-Received: by 2002:a7b:cb96:0:b0:3f0:5519:9049 with SMTP id
 m22-20020a7bcb96000000b003f055199049mr402752wmi.8.1682034198843; Thu, 20 Apr
 2023 16:43:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
In-Reply-To: <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 20 Apr 2023 16:42:42 -0700
Message-ID: <CAF7b7mqrLP1VYtwB4i0x5HC1eYen9iMvZbKerCKWrCFv7tDg5Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My reply to Peter earlier bounced from the mailing list due to the
attached images (sorry!). I've copied it below to get a record
on-list.

Just for completeness, the message ID of the bounced mail was
<CAF7b7mo68VLNp=3DQynfT7QKgdq=3Dd1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>

On Wed, Apr 19, 2023 at 2:53=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Wed, Apr 19, 2023 at 2:05=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> > > We considered sharding into several UFFDs. I do think it helps, but
> > > also I think there are two main problems with it...
> >
> > But I agree I can never justify that it'll always work.  If you or Anis=
h
> > could provide some data points to further support this issue that would=
 be
> > very interesting and helpful, IMHO, not required though.
>
> Axel covered the reasons for not pursuing the sharding approach nicely
> (thanks!). It's not something we ever prototyped, so I don't have any
> further numbers there.
>
> On Wed, Apr 19, 2023 at 2:05=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> >
> > > I think we could share numbers from some of our internal benchmarks,
> > > or at the very least give relative numbers (e.g. +50% increase), but
> > > since a lot of the software stack is proprietary (e.g. we don't use
> > > QEMU), it may not be that useful or reproducible for folks.
> >
> > Those numbers can still be helpful.  I was not asking for reproduceabil=
ity,
> > but some test to better justify this feature.
>
> I do have some internal benchmarking numbers on this front, although
> it's been a while since I've collected them so the details might be a
> little sparse.
>
> I've confirmed performance gains with "scalable userfaultfd" using two
> workloads besides the self-test:
>
> The first, cycler, spins up a VM and launches a binary which (a) maps
> a large amount of memory and then (b) loops over it issuing writes as
> fast as possible. It's not a very realistic guest but it at least
> involves an actual migrating VM, and we often use it to
> stress/performance test migration changes. The write rate which cycler
> achieves during userfaultfd-based postcopy (without scalable uffd
> enabled) is about 25% of what it achieves under KVM Demand Paging (the
> internal KVM feature GCE currently uses for postcopy). With
> userfaultfd-based postcopy and scalable uffd enabled that rate jumps
> nearly 3x, so about 75% of what KVM Demand Paging achieves. The
> attached "Cycler.png" illustrates this effect (though due to some
> other details, faster demand paging actually makes the migrations
> worse: the point is that scalable uffd performs more similarly to kvm
> demand paging :)
>
> The second is the redis memtier benchmark [1], a more realistic
> workflow where we migrate a VM running the redis server. With scalable
> userfaultfd, the client VM observes significantly higher transaction
> rates during uffd-based postcopy (see "Memtier.png"). I can pull the
> exact numbers if needed, but just from eyeballing the graph you can
> see that the improvement is something like 5-10x (at least) for
> several seconds. There's still a noticeable gap with KVM demand paging
> based-postcopy, but the improvement is definitely significant.
>
> [1] https://github.com/RedisLabs/memtier_benchmark
