Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96082AD2D
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 03:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741146803; cv=none; b=lSsMbll+7XQia0JjfS5qjRigaHm1tM+LLM17WkkDOfdRqgSsufWsp9X7aW9Lm7ecq1joJ/zMW53kGFda2eUU0m4nk8D2jey9UyoDhMNo+sw0VFlQAGZZxqj08/SUs+Tfp3s9qELDr7WiJkheKiV/xjtyE0u5UJJeI5/onRSb2Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741146803; c=relaxed/simple;
	bh=KYu15OTxtFs2mF10JuE1RcryLYxEkKONS/St8WU9dMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YftiyJxFIbtkbS6Uv5KxYRfnML6pGZex62Q0OtmpBKrUreY2KyFTtBYQQtwMobLtvgkOaWd4P/XnQni7vAyf2OgeIoOkLLHUba284gKZibEVLSuaFi1bzmQvZX7CIulHojtVbAGpY6w9mpzXMCPnkyeQk8e65vRuKjwuUGiNonE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJDNsxS2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJDNsxS2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741146800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mJRNWDqZaDl0D1j/RlDn06NEO5jFGolr9VYIE5+CIg=;
	b=XJDNsxS2SpIi3+Pue92aE8phL9nLO5hI9ahdXTAkI8FzlyB5j7qowNy4/lWAAIYK74bZhS
	5g6G/HNtl7nNG3aD6jCLaMSfXlW3xOajlUdniI7+LSM3RTdus6JO9PyyZ406quDodwNod+
	AxegR4dYAXt+CRHysMvN5QSeXdPnq/A=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-92c828n2OzqMh-M56zKkpg-1; Tue, 04 Mar 2025 22:53:17 -0500
X-MC-Unique: 92c828n2OzqMh-M56zKkpg-1
X-Mimecast-MFC-AGG-ID: 92c828n2OzqMh-M56zKkpg_1741146796
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2fec1f46678so15004154a91.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 19:53:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741146796; x=1741751596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mJRNWDqZaDl0D1j/RlDn06NEO5jFGolr9VYIE5+CIg=;
        b=nkc3M1PF4lEIEBm63i2v1aj1lobyCCl/OJqPSP/AcXc9/qwAzJK3Ir18JoIwBLIcU0
         O5A9IYMHgK0RVTE1oRpckId2sV4KCoQuz2VhGin8MUhY5kTCMVA/SGp848BSkMMMDzyh
         WJjZ/HMd1Q2M8E0xtM5qAHZJojKsi6izUpv4jMmjIem3pZ/la+Un6GuZbnI/VoN5RPSw
         MXP881l4ltxTZw7s4QqXZ6TKuv47h7jk0foL5DuotUJZR1HWMfy8TJd99EoBrw8yVWvb
         1qjXstq1fKNmVLv7FeQ0JVZcKUqLLZUdfqIkid1F6JjEzSyuCqmtIugUHlu08Bi3hn6G
         c5lA==
X-Forwarded-Encrypted: i=1; AJvYcCXxXHa+4nWmMulS/i6BC8YNvvYWj9PU5zVDdRWwSwMu7tlxkZ5BJkt5GPJO/PbP2M4u9xjfORw=@lists.linux.dev
X-Gm-Message-State: AOJu0YykAdeZ40o0mJlmmnE2MA57BTV2GdrLIpLusgUOXxHeuiqaOxtj
	epMItJkIMrmvEY+1DJl10arwmtHfQBVRkhPZMCfRqtfFRJ/OOgk/WZhifAx9T64e/BYm1WKTaOG
	6RY+5PSiHW0X6WTO7M5htd0oDmNp4ZgD5Q+uJ46QtE9h02QQCNgqxUg==
X-Gm-Gg: ASbGncuErhbpVG5OBSKJ8TX6glb17+BiJeJ3acnRkIIswsroOWqNvKBvkV/V/vkryk/
	oRYQ1jAUMG2dF4YM/Vtt+JuTGBJ9a5H+G6jROPpYSMBLjhQwRSo9q7js4vyxwmGhmIwxjbSoC3x
	kO4hfZaLpvyFaZ8Q5frNr423BsJWnUDV42lqHnJy1oVUQ0RZDfKPAWz+YwzWoqNmuZqe8vbsDuM
	0zvIsPKXKm3qUaOhvm43qFfaSTe4WUo2r2ndHthtTSgeRqQJEJFdxySk0GPaxV+TG0D/DsFSGGm
	G3dLUJ9cigpuaDs=
X-Received: by 2002:a05:6a21:150c:b0:1ee:cf13:d4b5 with SMTP id adf61e73a8af0-1f3495afc1dmr2823096637.39.1741146796422;
        Tue, 04 Mar 2025 19:53:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFuyA16zIv02ugj3FPLruOV0ZdxdHMNTCUw0ZHSpkP3eGnIKTFgv0oqMKMfRXj1Nc/YwnybSw==
X-Received: by 2002:a05:6a21:150c:b0:1ee:cf13:d4b5 with SMTP id adf61e73a8af0-1f3495afc1dmr2823058637.39.1741146796108;
        Tue, 04 Mar 2025 19:53:16 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7ddf20b8sm11041231a12.7.2025.03.04.19.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 19:53:15 -0800 (PST)
Message-ID: <af65c1ea-202a-4a60-ab13-0c325385b7ec@redhat.com>
Date: Wed, 5 Mar 2025 13:53:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/45] arm64: Support for Arm CCA in KVM
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WHIr5-1amwqKDyLPNkwR2xDqSfvDeNXxRJs7Hh7E0TI_1741146796
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/14/25 2:13 AM, Steven Price wrote:

[...]

> 
> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].
> 
> This series is based on v6.14-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v7
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v5
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> [2] https://lore.kernel.org/r/a7011738-a084-46fa-947f-395d90b37f8b%40arm.com
> 

I had a chance to test it by following Jean's instructions [1-2]. The guest can
boot up and kvmtool also can boot the guest. I'm listing the repositories I used
in case some body else want to give it a try.

[1] Jean's guide to build software components needed by ARM CCA stack
     https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU
[2] Jean's guide to build firmware needed by the emulated host

host
====
tf-rmm    https://git.codelinaro.org/linaro/dcap/rmm.git                       (cca/v4)
edk2:     git@github.com:tianocore/edk2.git                                    (edk2-stable202411)
tf-a:     https://git.codelinaro.org/linaro/dcap/tf-a/trusted-firmware-a.git   (cca/v4)
qemu      https://git.qemu.org/git/qemu.git                                    (stable-9.2)
linux     https://git.gitlab.arm.com/linux-arm/linux-cca.git                   (cca-host/v7)
buildroot https://github.com/buildroot/buildroot                               (master)

guest
=====
qemu      https://git.codelinaro.org/linaro/dcap/qemu.git                      (cca/latest)
kvmtool   https://gitlab.arm.com/linux-arm/kvmtool-cca                         (cca/latest)
linux     https://git.gitlab.arm.com/linux-arm/linux-cca.git                   (cca-guest/v7)

Command lines to start the host
================================
[gshan@virtlab723 host]$ cat start.sh
#!/bin/sh
HOST_PATH=/home/gshan/sandbox/qemu/host
GUEST_PATH=/home/gshan/sandbox/qemu/guest

sudo ${HOST_PATH}/qemu/build/qemu-system-aarch64                      \
-M virt,virtualization=on,secure=on,gic-version=3,acpi=off            \
-cpu max,x-rme=on -m 4G -smp 8                                        \
-serial mon:stdio -monitor none -nographic -nodefaults                \
-bios ${HOST_PATH}/tf-a/flash.bin                                     \
-kernel ${HOST_PATH}/linux/arch/arm64/boot/Image                      \
-initrd ${HOST_PATH}/buildroot/output/images/rootfs.cpio.xz           \
-device pcie-root-port,bus=pcie.0,chassis=1,id=pcie.1                 \
-device pcie-root-port,bus=pcie.0,chassis=2,id=pcie.2                 \
-device pcie-root-port,bus=pcie.0,chassis=3,id=pcie.3                 \
-device pcie-root-port,bus=pcie.0,chassis=4,id=pcie.4                 \
-device virtio-9p-device,fsdev=shr0,mount_tag=shr0                    \
-fsdev local,security_model=none,path=${GUEST_PATH},id=shr0           \
-netdev tap,id=tap1,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
-device virtio-net-pci,bus=pcie.2,netdev=tap1,mac=78:ac:44:2b:43:f0

Command lines to start the guest
================================
[gshan@virtlab723 guest]$ cat start_guest.sh
#!/bin/sh
key="VGhlIHJlYWxtIGd1ZXN0IHBlcnNvbmFsaXphdGlvbiBrZXkga"
key+="W4gZm9ybWF0IG9mIGJhc2U2NCAgICAgICAgIA=="

qemu-system-aarch64 -enable-kvm                                                     \
-object rme-guest,id=rme0,measurement-algorithm=sha512,personalization-value=${key} \
-M virt,gic-version=3,its=on,confidential-guest-support=rme0                        \
-cpu host -smp 2 -m 1024M                                                           \
-serial mon:stdio -monitor none -nographic -nodefaults                              \
-kernel /mnt/linux/arch/arm64/boot/Image                                            \
-initrd /mnt/buildroot/output/images/rootfs.cpio.xz                                 \
-append earlycon=pl011,mmio,0x10009000000

Thanks,
Gavin

