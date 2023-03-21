Received: from out-34.mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3457533F0
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 18:42:01 +0000 (UTC)
Date: Tue, 21 Mar 2023 19:41:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679424120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DIC31lOJGI6TEZYluCgHNpwEWB1FmTnLvCT8xC83L7k=;
	b=YiZbiHD3gZey054BxlRxLWzl7L1YfgP7LQxnneIwom/y671cu1hf4BC0PoFDxAhxYZ0D01
	kh6Ya7govaVCJE/I8T/tt3ZwU21DxCRzpjNlQbXRS5EoB3sVDg4Tlx1s9xOBUaUc0QHXu0
	p8BcRbAmk/iUxvdCieu/NRaXo9GyTgA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 30/30] arm64: Add an efi/run script
Message-ID: <20230321184158.phwwbsk5mv7qwhpa@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-31-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213101759.2577077-31-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 13, 2023 at 10:17:59AM +0000, Nikos Nikoleris wrote:
> This change adds a efi/run script inspired by the one in x86. This
> script will setup a folder with the test compiled as an EFI app and a
> startup.nsh script. The script launches QEMU providing an image with
> EDKII and the path to the folder with the test which is executed
> automatically.
> 
> For example:
> 
> $> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256

This should be

./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256

but I can't get any tests to run through ./arm/efi/run. All of them
immediately die with a DABT_EL1. I can get the tests to run (and pass) by
manually booting into UEFI with the FAT partition pointing at the parent
directory

 $QEMU -nodefaults -machine virt -accel tcg -cpu cortex-a57 \
       -device pci-testdev -display none -serial stdio \
       -bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
       -drive file.dir=efi-tests/,file.driver=vvfat,file.rw=on,format=raw,if=virtio

and then, for example for the timer test, doing

 fs0:
 cd timer
 timer.efi

but the script never works.

Thanks,
drew
