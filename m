Received: from out-57.mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B747C144
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 09:06:43 +0000 (UTC)
Date: Tue, 20 Jun 2023 11:06:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687252001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZhslkC1rQ0aLtForUm8Fg+bP1zBb90Ucb1xGcqnuYk=;
	b=nbjuc1pix0rXF0fhLAOajGau+7FlP/WVv7MncllKd+TWFOpp26KunhpbEsFUoh483/OOSm
	y1ZhpvS2cLWFuUEtSf0JOJG/h9PcqrDjYinnO8qDc4JCK13BQWue7HEKfIyWmV2lrNu+Sm
	x9vZTtEaIO9VAXlwe8ZwJtv4QYka0Sk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, 
	linux-s390@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	shan.gavin@gmail.com
Subject: Re: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties
 for accelerator
Message-ID: <20230620-f496c5f56a78acc5529762a4@orel>
References: <20230615062148.19883-1-gshan@redhat.com>
 <20230619-339675e424da033000049f83@orel>
 <766a1dc4-a5ad-725a-b25e-438bf1387a4f@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <766a1dc4-a5ad-725a-b25e-438bf1387a4f@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 20, 2023 at 02:13:22PM +1000, Gavin Shan wrote:
> Hi Drew,
> 
> On 6/19/23 18:45, Andrew Jones wrote:
> > On Thu, Jun 15, 2023 at 04:21:48PM +1000, Gavin Shan wrote:
> > > There are extra properties for accelerators to enable the specific
> > > features. For example, the dirty ring for KVM accelerator can be
> > > enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
> > > extra properties for the accelerators aren't supported. It makes
> > > it's impossible to test the combination of KVM and dirty ring
> > > as the following error message indicates.
> > > 
> > >    # cd /home/gavin/sandbox/kvm-unit-tests/tests
> > >    # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
> > >      ACCEL=kvm,dirty-ring-size=65536 ./its-migration
> > >       :
> > >    BUILD_HEAD=2fffb37e
> > >    timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
> > >    -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
> > >    -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
> > >    -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
> > >    -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
> > >    qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
> > > 
> > > Allow to specify extra properties for accelerators. With this, the
> > > "its-migration" can be tested for the combination of KVM and dirty
> > > ring.
> > > 
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > > ---
> > > v3: Split $ACCEL to $ACCEL and $ACCEL_PROPS in get_qemu_accelerator()
> > >      and don't print them as output, suggested by Drew.
> > > ---
> > >   arm/run               | 12 ++++--------
> > >   powerpc/run           |  5 ++---
> > >   s390x/run             |  5 ++---
> > >   scripts/arch-run.bash | 21 +++++++++++++--------
> > >   x86/run               |  5 ++---
> > >   5 files changed, 23 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index c6f25b8..d9ebe59 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -10,10 +10,8 @@ if [ -z "$KUT_STANDALONE" ]; then
> > >   fi
> > >   processor="$PROCESSOR"
> > > -accel=$(get_qemu_accelerator) ||
> > > -	exit $?
> > > -
> > > -if [ "$accel" = "kvm" ]; then
> > > +get_qemu_accelerator || exit $?
> > > +if [ "$ACCEL" = "kvm" ]; then
> > >   	QEMU_ARCH=$HOST
> > >   fi
> > > @@ -23,11 +21,9 @@ qemu=$(search_qemu_binary) ||
> > >   if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> > >      [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> > >      [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> > > -	accel=tcg
> > > +	ACCEL="tcg"
> > >   fi
> > 
> > As I pointed out in the v2 review we can't just s/accel/ACCEL/ without
> > other changes. Now ACCEL will also be set when the above condition
> > is checked, making it useless. Please ensure the test case that commit
> > c7d6c7f00e7c ("arm/run: Use TCG with qemu-system-arm on arm64 systems")
> > fixed still works with your patch.
> > 
> 
> Sorry that I missed your comments for v2. In order to make the test case
> in c7d6c7f00e7c working, we just need to call set_qemu_accelerator() after
> the chunk of code, like below. When $ACCEL is set to "tcg" by the conditional
> code, it won't be changed in the following set_qemu_accelerator().
> 
> Could you Please confirm if it looks good to you so that I can integrate
> the changes to v4 and post it.
> 
> arm/run
> --------
> 
> processor="$PROCESSOR"
> 
> if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
>    [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
>    [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
>         ACCEL="tcg"
> fi
> 
> set_qemu_accelerator || exit $?
> if [ "$ACCEL" = "kvm" ]; then
>         QEMU_ARCH=$HOST
> fi
>

Looks fine, but please give it a test run.

Thanks,
drew
