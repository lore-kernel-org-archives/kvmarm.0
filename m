Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ACB17993
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756946838; cv=none; b=oC8OKUnngaKe17SkX6jPLCHYW80pVukSgOgFoBHQSq9DF+OVfqsXDgOxFu3WNEytu/btvxma9USwnlUrJu3ZBxUs2fYu0v3JMB4eIb1ewt0OGIPJGAwDySC0dEgcErEOo2gr5NS0EJwszIVjxRjtyb2zVmrJPjLi6mTWftArduc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756946838; c=relaxed/simple;
	bh=fgtAxIt0auoxLZHGqJqmkLBpAc93q8HByfWt9LLtHlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=udpGTWIxwzX/nFsJjUcAph/+kuVDQNYAd/ZowFv71AM+gkEC4y2nCST8rv4eQnOSrOvUp4XH/Z8s+lOrJP2gEMSmKMR4vjTA4W4eXepfT0MY6RPSSV061nw3UpHVunHNa4rXAX+Ffiyz+yDDpQDBNlD7L5QUwgiw+UZEaVAL/no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BvB2xryS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BvB2xryS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756946835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5rBTWZqYxMCbwIRVUHkkykppHi5qw7KCSrBOdLy9bbQ=;
	b=BvB2xrySAbNl03yws2DvTc+VFks06cYRFJnVO3D0vUJfx9ehHGlif6mCJps3kYQHsb/N0K
	9PlkoO3NAqNySyOnKx/noQXmKy6my3HgZ4yw62kQNf2ZLnlVEsFoJfgWhtkDBEo0as0JiV
	hLQSKVtp85V69w44vX96z2Bym/bNl6w=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-w3Yt-Vj1N3SMv0v6H39ZYg-1; Wed, 03 Sep 2025 20:47:11 -0400
X-MC-Unique: w3Yt-Vj1N3SMv0v6H39ZYg-1
X-Mimecast-MFC-AGG-ID: w3Yt-Vj1N3SMv0v6H39ZYg_1756946830
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b4fc06ba4c1so97054a12.1
        for <kvmarm@lists.linux.dev>; Wed, 03 Sep 2025 17:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756946830; x=1757551630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rBTWZqYxMCbwIRVUHkkykppHi5qw7KCSrBOdLy9bbQ=;
        b=i01iOTIqZLjCdbX74cewAMxc2cBQcyt8v54uNPkq6q+Th4zsgYxLNimmd2U3iEMBKl
         +2SzdLvoTTeOYvm2cpsWJhJuraRYB8R+D1BWKhtdEpc8X1CrULTQIrmskMgr5Xg9u0Gr
         0hpE/xVVmCvykFrHUyXJV3pnTtnvpoUhu9CZF5bXpOWVbmp2XjNHtj9hJdZD+xEWPK7r
         jjknNyvf8lKgiBjrl3MmAvFN9jsnfzFXAc5k1xr1fxpzH1FZwM3LPNdLgzr0eO4XY99R
         zZIaUsZ4ai8A29UhCkhSQIYcVHv8j2lD0ofp7C/5dGIeNL7g/YgepNFkYPPqLCcAa8NM
         jyLw==
X-Forwarded-Encrypted: i=1; AJvYcCXezu6c2+agyzhwiJynylrpVKF6hrahQdJLdqNmovz1QUc75eCQn98hInMIY6er05eN0PmPuCs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSLcLEeLvNbj/gafiy/e3N+YBvqqgYtVh8FRBksKkH/0ce9j70
	2VmD4TqeJUbPbmdMIssj7RvkVhBRd6Me+PPaut8KjO+yDcr3+dGOVoOMBR+xwU+FzionQVvf6Vi
	7ZGOErWKM3zDuQywUV9MyWwsOWgk3g9hLkoshTCyEyU1D4PMs+gkV8CaFpA==
X-Gm-Gg: ASbGncshwewqmDdqc5jzY8gRSCyAmSUHLoGopBGH9eddIPlAD9jDyk33FryEZggIrfl
	VL9hbR5WL3qCMx+o1MmxzOs+15a+pb9sopnbcDCpMxXHVWObRSEq8tdH26iDlqTxmutYm70mfYJ
	rgknFER/Cq7H4RJtfW0fIMHzzyv3yoBeyPLGvZ5X3RXa3D8PfEuUNGNrjVC7yIdHR4NCVkIMSuY
	I5vIOQD257YGQlq1YhQ/umU++uK+2zYIz4BLDxF2pL/3sLs9qPg5jXnZt7HfYN3Xr6zhNtw4Ga7
	hOPapXVEXgp2ocaeG58S2n3mZhC09uN963I5f2KaohcssU5ii/MbfU9+kj/wLz/2ywhWzG9lhjd
	omABP
X-Received: by 2002:a05:6a20:c489:b0:246:2c:fc with SMTP id adf61e73a8af0-246002c0243mr7913942637.48.1756946830303;
        Wed, 03 Sep 2025 17:47:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIE1heha6NLiL0Mkgu6redBGDU2JQIw5VRfT/dIGF69ITV4kWD+34/z44Af0YiNh4zlPvwtw==
X-Received: by 2002:a05:6a20:c489:b0:246:2c:fc with SMTP id adf61e73a8af0-246002c0243mr7913928637.48.1756946829873;
        Wed, 03 Sep 2025 17:47:09 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327e21d14a8sm17973206a91.2.2025.09.03.17.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 17:47:09 -0700 (PDT)
Message-ID: <2aa76e3c-1e97-46d8-a8b7-c13cbbf05e8b@redhat.com>
Date: Thu, 4 Sep 2025 10:46:59 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/43] arm64: Support for Arm CCA in KVM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3Y6KmQFQnsVLoHulzPelX2Q726uFdii_UbxZwBHYKJI_1756946830
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/21/25 12:55 AM, Steven Price wrote:
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA).
> 
> The related guest support was merged for v6.14-rc1 so you no longer need
> that separately.
> 
> There are a few changes since v9, many thanks for the review
> comments. The highlights are below, and individual patches have a changelog.
> 
>   * Fix a potential issue where the host was walking the stage 2 page tables on
>     realm destruction. If the RMM didn't zero when undelegated (which it isn't
>     required to) then the kernel would attempt to work the junk values and crash.
> 
>   * Avoid RCU stall warnings by correctly settign may_block in
>     kvm_free_stage2_pgd().
> 
>   * Rebased onto v6.17-rc1.
> 
> Things to note:
> 
>   * The magic numbers for capabilities and ioctls have been updated. So
>     you'll need to update your VMM. See below for the updated kvmtool branch.
> 
>   * This series doesn't attempt to integrate with the guest-memfd changes that
>     are being discussed (see below).
> 
>   * Vishal raised an important question about what to do in the case of
>     undelegate failures (also see below).
> 

[...]

I tried to boot a guest using the following combinations, nothing obvious went to
wrong except several long existing issues (described below). So feel free to add:

Tested-by: Gavin Shan <gshan@redhat.com>

Combination
===========
host.tf-a        https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git      (v2.13-rc0)
host.tf-rmm      https://git.codelinaro.org/linaro/dcap/rmm                       (cca/v8)
host.edk2        git@github.com:tianocore/edk2.git                                (edk2-stable202411)
host.kernel      git@github.com:gwshan/linux.git                                  (cca/host-v10) (this series)
host.qemu        https://git.qemu.org/git/qemu.git                                (stable-9.2)
host.buildroot   https://github.com/buildroot/buildroot                           (master)
guest.qemu       https://git.codelinaro.org/linaro/dcap/qemu.git                  (cca/latest) (with linux-headers sync'ed)
guest.kvmtool    https://gitlab.arm.com/linux-arm/kvmtool-cca                     (cca/latest)
guest.edk2       https://git.codelinaro.org/linaro/dcap/edk2                      (cca/latest)
guest.kernel     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (v6.17.rc3)
guest.buildroot  https://github.com/buildroot/buildroot                           (master)

Script to start the host
========================
gshan@nvidia-grace-hopper-01:~/sandbox/qemu/host$ cat start.sh
#!/bin/sh
HOST_PATH=/home/gshan/sandbox/qemu/host
GUEST_PATH=/home/gshan/sandbox/qemu/guest
IF_UP_SCRIPT=/etc/qemu-ifup-gshan
IF_DOWN_SCRIPT=/etc/qemu-ifdown-gshan

sudo ${HOST_PATH}/qemu/build/qemu-system-aarch64                        \
-M virt,virtualization=on,secure=on,gic-version=3,acpi=off              \
-cpu max,x-rme=on -m 3G -smp 8                                          \
-serial mon:stdio -monitor none -nographic -nodefaults                  \
-bios ${HOST_PATH}/tf-a/flash.bin                                       \
-kernel ${HOST_PATH}/linux/arch/arm64/boot/Image                        \
-initrd ${HOST_PATH}/buildroot/output/images/rootfs.cpio.xz             \
-device pcie-root-port,bus=pcie.0,chassis=1,id=pcie.1                   \
-device pcie-root-port,bus=pcie.0,chassis=2,id=pcie.2                   \
-device pcie-root-port,bus=pcie.0,chassis=3,id=pcie.3                   \
-device pcie-root-port,bus=pcie.0,chassis=4,id=pcie.4                   \
-device virtio-9p-device,fsdev=shr0,mount_tag=shr0                      \
-fsdev local,security_model=none,path=${GUEST_PATH},id=shr0             \
-netdev tap,id=tap1,script=${IF_UP_SCRIPT},downscript=${IF_DOWN_SCRIPT} \
-device virtio-net-pci,bus=pcie.2,netdev=tap1,mac=b8:3f:d2:1d:3e:f1

Script to start the guest
=========================
gshan@nvidia-grace-hopper-01:~/sandbox/qemu/guest$ cat start_full.sh
#!/bin/sh
key="VGhlIHJlYWxtIGd1ZXN0IHBlcnNvbmFsaXphdGlvbiBrZXkgaW4gZm9ybWF0IG9mIGJhc2U2NCAgICAgICAgIA=="
IF_UP_SCRIPT=/etc/qemu-ifup
IF_DOWN_SCRIPT=/etc/qemu-ifdown

qemu-system-aarch64 -enable-kvm \
-object rme-guest,id=rme0,measurement-algorithm=sha512,personalization-value=${key} \
-M virt,gic-version=3,confidential-guest-support=rme0                               \
-cpu host -smp 4 -m 2G -boot c                                                      \
-serial mon:stdio -monitor none -nographic -nodefaults                              \
-bios /mnt/edk2/Build/ArmVirtQemu-AARCH64/RELEASE_GCC5/FV/QEMU_EFI.fd               \
-device pcie-root-port,bus=pcie.0,chassis=1,id=pcie.1                               \
-device pcie-root-port,bus=pcie.0,chassis=2,id=pcie.2                               \
-drive file=/mnt/rhel10.qcow2,if=none,id=drive0                                     \
-device virtio-blk-pci,id=virtblk0,bus=pcie.1,drive=drive0,num-queues=4             \
-netdev tap,id=tap0,script=${IF_UP_SCRIPT},downscript=${IF_DOWN_SCRIPT}             \
-device virtio-net-pci,bus=pcie.2,netdev=tap0,mac=b8:3f:d2:1d:3e:f9

Issues
======
1. virtio-iommu isn't supported by QEMU. The guest kernel becomes stuck at IOMMU
probing time where the endpoint's capabilities is queried by sending request over
virtio device's vring and the response is expected to be fed by QEMU. The request
can't be seen by QEMU due to the wrong IOMMU address translation used in QEMU as
virtio-iommu provides a different IOMMU address translation operations to override
the platform one, leading the DMA address (in the shared space) can't be properly
recognized. The information has been shared to Jean.

2. 'reboot' command doesn't work in the guest. QEMU complains some registers aren't
accessible from QEMU. I didn't sorted out a workaround for this.

3. HMP command 'dump-guest-memory' causes QEMU to exit abnormally. The cause is the
realm is reconfigured when the VM is resumed after the guest memory is dumped. The
reconfiguration is rejected by the host, leading QEMU's abnormal exit. The fix would
be to avoid the reconfiguration on the realm. The issue was originally reported by
Fujitsu and all the information has been shared to Fujitsu.

4. In QEMU, the CPU property 'kvm-no-adjvtime' can't be set to off. Otherwise, QEMU
tries to access the timer registers, which have been hidden by the host. So we need
to take the parameter (for QEMU) to by pass it: "-cpu host,kvm-no-adjvtime=on".

5. I didn't try virtio-mem and memory balloon, which isn't expected to work, especially
when the guest memory is hot added or hot removed.

Thanks,
Gavin


