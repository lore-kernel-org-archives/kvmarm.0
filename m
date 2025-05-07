Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E410A289E21
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746634222; cv=none; b=RkqkZSgBbM0BdXbhFSiMU6rO21guRC/6On74JZ6nUCuY/+4yBZeUVivdfHiTWXCNZXE0SlZFqBmJX14072Gd55M8gCsp0DKTuLdfVjugrpcF3uZoMRXQRoMC+4RcbqGkx5o6BUCVJKHiaiqkiTTuqMnAAANsHTV6iM58pthD5KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746634222; c=relaxed/simple;
	bh=c+bjxYhVvROX1KuKu5+NimZFmSoB/QlIWwA3fwTaHe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cApxAlUrVU5dlXpi4TThipjVOouPuSfXNH6Emp4Uepii0C93AsUzzsvxHM/Q5gQZj12mM7yyVZakIy08x83th2wqMU8eeX2UUnCUH1RH74+4koZQIzvrxQTllVMCALbz3gKrQxkAfyiXW5X2Y9OicTah9KJ4IqGf/SyL7vpu/II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mBCAnAjD; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mBCAnAjD"
Date: Wed, 7 May 2025 18:10:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746634212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiZ31VdvRQ6VkYliXJ2lIgISyRlmOkDR5mD/TR0GNrQ=;
	b=mBCAnAjDrOlyA/gWMCdvr9yEcQvawdVZPybIJtBkNa03TXy6t+4fWpUDOV/VRRsAVOfYYy
	Gf/WlIPkGWUwXrG7ycWyWXxTMCDlKluWEo4Exg4ICH3453d8oQ54/FmNRZIomdLki4TcGd
	YOE5MAL2C3ZcTFfygytLkHpW6IK+DpA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/16] scripts: Refuse to run the tests
 if not configured for qemu
Message-ID: <20250507-9143a202e9745535dd43b5a8@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-7-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-7-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:46PM +0100, Alexandru Elisei wrote:
> Arm and arm64 support running the tests under kvmtool. kvmtool has a
> different command line syntax for configuring and running a virtual
> machine, and the automated scripts know only how to use qemu.
> 
> One issue with that is even though the tests have been configured for
> kvmtool (with ./configure --target=kvmtool), the scripts will use qemu to
> run the tests, and without looking at the logs there is no indication that
> the tests haven't been run with kvmtool, as configured.
> 
> Another issue is that kvmtool uses a different address for the UART and
> when running the tests with qemu via the scripts, this warning is
> displayed:
> 
> WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> 
> which might trip up an unsuspected user.
> 
> There are four different ways to run a test using the test infrastructure:
> with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> parameters (only the arm directory is mentioned here because the tests can
> be configured for kvmtool only on arm and arm64), and by creating
> standalone tests.
> 
> run_tests.sh ends up execuing either arm/run or arm/efi/run, so add a check

executing

> to these two scripts for the test target, and refuse to run the test if
> kvm-unit-tests has been configured for kvmtool.
> 
> mkstandalone.sh also executes arm/run or arm/efi run, but the usual use
> case for standalone tests is to compile them on one machine, and then to
> run them on a different machine. This two step process can be time
> consuming, so save the user time (and frustration!) and add a check
> directly to mkstandalone.sh.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/efi/run             |  3 +++
>  arm/run                 |  4 ++++
>  scripts/mkstandalone.sh |  3 +++
>  scripts/vmm.bash        | 14 ++++++++++++++
>  4 files changed, 24 insertions(+)
>  create mode 100644 scripts/vmm.bash
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 8f41fc02df31..53d71297cc52 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -11,6 +11,9 @@ if [ ! -f config.mak ]; then
>  fi
>  source config.mak
>  source scripts/arch-run.bash
> +source scripts/vmm.bash
> +
> +check_vmm_supported
>  
>  if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
>  	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> diff --git a/arm/run b/arm/run
> index ef58558231b7..56562ed1628f 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -7,7 +7,11 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	fi
>  	source config.mak
>  	source scripts/arch-run.bash
> +	source scripts/vmm.bash
>  fi
> +
> +check_vmm_supported
> +
>  qemu_cpu="$TARGET_CPU"
>  
>  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index c4ba81f18935..4f666cefe076 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -6,6 +6,9 @@ if [ ! -f config.mak ]; then
>  fi
>  source config.mak
>  source scripts/common.bash
> +source scripts/vmm.bash
> +
> +check_vmm_supported
>  
>  temp_file ()
>  {
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> new file mode 100644
> index 000000000000..39325858c6b3
> --- /dev/null
> +++ b/scripts/vmm.bash
> @@ -0,0 +1,14 @@
> +source config.mak
> +
> +function check_vmm_supported()
> +{
> +	case "$TARGET" in
> +	qemu)
> +		return 0
> +		;;
> +	*)
> +		echo "$0 does not support target '$TARGET'"
> +		exit 2
> +		;;
> +	esac
> +}

Hmm. We now have configure saying one thing for arm/arm64 and this
function saying another. Assuming this is just temporary and will
be resolved in the next patches, then that's probably OK, though.

Thanks,
drew
