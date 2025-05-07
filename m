Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D6728C2B9
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746634503; cv=none; b=Bf+1yct0HlOwgAi03SwqTzt+nFdFtQ0T0upxSCiQ4d5+KqdIqGyLvK8osL2ftXfvK96XizPKvYjSSki3zTp9UxTq+xhIsvMa3BvoN5PR2f4uV0wlAcj0TaE4LUtwDClfMuOOLdTQdpvUxIYndnNdduDBZvt56kqZHPW5/eUTQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746634503; c=relaxed/simple;
	bh=3RW4leM8BnNjAy5TU2cpYtfbDvB0RKkpGpJF18ukiBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q35wK5zF5l2P8p1iqr5oSJGXItl6nTyRR3jElIWJg5e8kcdEHLpecCU7Ec7dEWPM3wteG/8zD92SE40e+vHr2JMStFJT2ot1o7r8OU5bUt0I17AKn07n0Z/N5viwpDDgzf5jc5H5trEftBJIMaJ8EOwFKIJYhddyyNLNFsZnfHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9296F16F2;
	Wed,  7 May 2025 09:14:49 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8307E3F58B;
	Wed,  7 May 2025 09:14:56 -0700 (PDT)
Date: Wed, 7 May 2025 17:14:53 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
	david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/16] scripts: Refuse to run the tests
 if not configured for qemu
Message-ID: <aBuG_fx2dc99mXCU@raptor>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-7-alexandru.elisei@arm.com>
 <20250507-9143a202e9745535dd43b5a8@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507-9143a202e9745535dd43b5a8@orel>

Hi Drew,

On Wed, May 07, 2025 at 06:10:08PM +0200, Andrew Jones wrote:
> On Wed, May 07, 2025 at 04:12:46PM +0100, Alexandru Elisei wrote:
> > Arm and arm64 support running the tests under kvmtool. kvmtool has a
> > different command line syntax for configuring and running a virtual
> > machine, and the automated scripts know only how to use qemu.
> > 
> > One issue with that is even though the tests have been configured for
> > kvmtool (with ./configure --target=kvmtool), the scripts will use qemu to
> > run the tests, and without looking at the logs there is no indication that
> > the tests haven't been run with kvmtool, as configured.
> > 
> > Another issue is that kvmtool uses a different address for the UART and
> > when running the tests with qemu via the scripts, this warning is
> > displayed:
> > 
> > WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> > 
> > which might trip up an unsuspected user.
> > 
> > There are four different ways to run a test using the test infrastructure:
> > with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> > parameters (only the arm directory is mentioned here because the tests can
> > be configured for kvmtool only on arm and arm64), and by creating
> > standalone tests.
> > 
> > run_tests.sh ends up execuing either arm/run or arm/efi/run, so add a check
> 
> executing

Ack.

> 
> > to these two scripts for the test target, and refuse to run the test if
> > kvm-unit-tests has been configured for kvmtool.
> > 
> > mkstandalone.sh also executes arm/run or arm/efi run, but the usual use
> > case for standalone tests is to compile them on one machine, and then to
> > run them on a different machine. This two step process can be time
> > consuming, so save the user time (and frustration!) and add a check
> > directly to mkstandalone.sh.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/efi/run             |  3 +++
> >  arm/run                 |  4 ++++
> >  scripts/mkstandalone.sh |  3 +++
> >  scripts/vmm.bash        | 14 ++++++++++++++
> >  4 files changed, 24 insertions(+)
> >  create mode 100644 scripts/vmm.bash
> > 
> > diff --git a/arm/efi/run b/arm/efi/run
> > index 8f41fc02df31..53d71297cc52 100755
> > --- a/arm/efi/run
> > +++ b/arm/efi/run
> > @@ -11,6 +11,9 @@ if [ ! -f config.mak ]; then
> >  fi
> >  source config.mak
> >  source scripts/arch-run.bash
> > +source scripts/vmm.bash
> > +
> > +check_vmm_supported
> >  
> >  if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
> >  	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> > diff --git a/arm/run b/arm/run
> > index ef58558231b7..56562ed1628f 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -7,7 +7,11 @@ if [ -z "$KUT_STANDALONE" ]; then
> >  	fi
> >  	source config.mak
> >  	source scripts/arch-run.bash
> > +	source scripts/vmm.bash
> >  fi
> > +
> > +check_vmm_supported
> > +
> >  qemu_cpu="$TARGET_CPU"
> >  
> >  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> > diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> > index c4ba81f18935..4f666cefe076 100755
> > --- a/scripts/mkstandalone.sh
> > +++ b/scripts/mkstandalone.sh
> > @@ -6,6 +6,9 @@ if [ ! -f config.mak ]; then
> >  fi
> >  source config.mak
> >  source scripts/common.bash
> > +source scripts/vmm.bash
> > +
> > +check_vmm_supported
> >  
> >  temp_file ()
> >  {
> > diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> > new file mode 100644
> > index 000000000000..39325858c6b3
> > --- /dev/null
> > +++ b/scripts/vmm.bash
> > @@ -0,0 +1,14 @@
> > +source config.mak
> > +
> > +function check_vmm_supported()
> > +{
> > +	case "$TARGET" in
> > +	qemu)
> > +		return 0
> > +		;;
> > +	*)
> > +		echo "$0 does not support target '$TARGET'"
> > +		exit 2
> > +		;;
> > +	esac
> > +}
> 
> Hmm. We now have configure saying one thing for arm/arm64 and this
> function saying another. Assuming this is just temporary and will
> be resolved in the next patches, then that's probably OK, though.

This is resolved in the last patch. Wanted to add this in case someone doesn't
apply the entire series and they end up with partial kvmtool support.

And thanks for having a look so fast!

Alex

> 
> Thanks,
> drew
