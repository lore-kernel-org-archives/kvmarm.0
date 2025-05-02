Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9E420311
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 00:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146781; cv=none; b=QFJ2MRnhC/qNKPI2dqOWTvKXGgO7B7+Wd6BLp5IpuPpZsfQyh6X7yf0YQ60obGZyPFov+V1Y4DBUbJLvqfEFA22MXvXTgcIuF7zOwCh4v1XAGwO2/UKZdZS7ZUs9+Pe0lAgpw9P2siZXDWBLJrPgXYaQt9w0X0lT5G4Mq7xtNTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146781; c=relaxed/simple;
	bh=jpFTB7+Fe9GetEM5S34MRK+mjeh4+kvCjqKf5I8R+DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UC1v5GwBlaisL9i6CX1OpWG9belmOF99tv3JSkGqyolfnn5h23PajM+VA11cROjEUJYZE3vfGz1MXHTT6UOJb5QwT1TR0dKyzctc4JYggqpTU28nHwYSg4O6zs4HGhmN/QaEN5BoNzjEV0IXNDnsXiAORO74du4ogHGyZW0GWK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fbxi0bTT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fbxi0bTT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746146777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RzVNeQVSuEn+p0XG3JKage9a7jPIIY+5Xq1YW6zJmmc=;
	b=Fbxi0bTTc2pssX1Rp98C4emA4S1Pma690ST+KY9c7qD1kxexCUdxgXt5/e7RdVOrhfj05u
	5wKK8t6kPYS4E+TZcq3EvZuAPYkP6eoLzO75Cp3K74JlfAYCKeW3imCNLPInmGyBBrtAmZ
	Bby7E5B2XPmvOFZT7RJeheZD51RjGTI=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-kVL_Ms4_P9a1MIJGrb9dAA-1; Thu, 01 May 2025 20:46:16 -0400
X-MC-Unique: kVL_Ms4_P9a1MIJGrb9dAA-1
X-Mimecast-MFC-AGG-ID: kVL_Ms4_P9a1MIJGrb9dAA_1746146775
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b16837f1874so982866a12.2
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 17:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746146770; x=1746751570;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RzVNeQVSuEn+p0XG3JKage9a7jPIIY+5Xq1YW6zJmmc=;
        b=NDnzZVUqgjITwfb/LYCOTTBKeWupLjOYoc+MweanAwpqQgPrsnnW/XKrgQRqCBTpe1
         zsDeUWWmRhNBkjWpn3DP01yvk01F+W5n9Ff6hRKed0K/cKbPTlMeqQuqb+WKGG1HUMdA
         H5ubSOqKYZ8JL/dvrmNYs7fhyYbHW3WBO3ZoNFQSKhIrT9vUt1DInGx4nuYRoYMF2eiW
         RVg6ABYVkIXTZc1v/wZgDx9awd8EagSK7sf6jMWq0YZnSLnKyvLJe6IiX937A2m/stdF
         zBBLZnbZ+bdGELH0pBsILIJxsX///4OjrkYeQZ2/8aaWInCoc1fh282ZHlW8mFvDRle1
         vxeA==
X-Forwarded-Encrypted: i=1; AJvYcCXzy7pSZgFOPRxKBc4APtMxn2+0kWMfbtlLZ6c3tFPtgsTc2G9ojNctCkrZxo7LRrEg58FRw0o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7W5Fva+t0IvtPseys1ZYPd8cQjnP5ywKd909tKUf3dtoeORfG
	cSHsjs5w56I9GGfxtX76JlyXTYTHNkFeqOfZsZOAxKdsYO83jueYlGW6hpCPPG6E6iTH5MXNJyN
	5M+avAG79wY0ju4CWydzkoiuMoJ7rtCHzhiNcHBhgc43cdNnWQ4PloQ==
X-Gm-Gg: ASbGnctjDotO1iVFSASZCjbMx8uo9zR2/JiAonywzQ95B4Nmv2MHnKqwJmQoZfFw83q
	J0Ai2pOvs8oktBBDAFUmSL9Ie5gAxiIeLbxqBM49mrHdz+jiVGCht9ozVuyeJEs8N+ZLICruKWX
	EAo2vz2dDqbg0oW2jnaLN2k3EX9Q0E8jsFawHpXrApVg0BEaEZJvSno6V4q29dQ0iRme9ExxXiX
	NPuuW0f0rJuypSHgxTyhKbEwBjWRP8I/YyhZpTgD9MoyO0i+hJzJsKZEzhulIxghHybYf3wyw9G
	IQTUiu7l36T4
X-Received: by 2002:a17:90b:5867:b0:2ee:7c65:ae8e with SMTP id 98e67ed59e1d1-30a4e5959b2mr1601375a91.11.1746146770089;
        Thu, 01 May 2025 17:46:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiL3PaKpNDJ5GxpdjSgGj8jbC5Fiag7sifRcEucRKRUwL1HksU1Lw6rYRFG+qnRZ9Au1gJFw==
X-Received: by 2002:a17:90b:5867:b0:2ee:7c65:ae8e with SMTP id 98e67ed59e1d1-30a4e5959b2mr1601341a91.11.1746146769647;
        Thu, 01 May 2025 17:46:09 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34826677sm4323342a91.40.2025.05.01.17.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 17:46:08 -0700 (PDT)
Message-ID: <fa874ef5-5da5-44de-a9d0-24663eb684a0@redhat.com>
Date: Fri, 2 May 2025 10:46:00 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/43] arm64: Support for Arm CCA in KVM
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
References: <20250416134208.383984-1-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-1-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gatm0QYoMJafgaX9acPbnN3-brD6yUZwUefvkX0osiQ_1746146775
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:

[...]

> 
> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].
> 
> This series is based on v6.15-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v8
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v6
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> [2] https://lore.kernel.org/r/20250408105225.4002637-17-maz%40kernel.org
> 

I got a chance to try the following combination, the guest can boot using
qemu/kvmtool except a RCU stall is observed (more details provided below)

host.tf-rmm      https://git.codelinaro.org/linaro/dcap/rmm.git                      (cca/v8)
host.edk2        git@github.com:tianocore/edk2.git                                   (edk2-stable202411)
host.tf-a        https://git.codelinaro.org/linaro/dcap/tf-a/trusted-firmware-a.git  (cca/v4)
host.qemu        https://git.qemu.org/git/qemu.git                                   (stable-9.2)
host.linux       https://git.gitlab.arm.com/linux-arm/linux-cca.git                  (cca-host/v8)
host.buildroot   https://github.com/buildroot/buildroot                              (master)
guest.qemu       https://git.codelinaro.org/linaro/dcap/qemu.git                     (cca/latest)
guest.kvmtool    https://gitlab.arm.com/linux-arm/kvmtool-cca                        (cca/latest)
guest.buildroot  https://github.com/buildroot/buildroot                              (master)

RCU stall report
----------------

[ 7816.381336] rcu: INFO: rcu_preempt self-detected stall on CPU
[ 7816.382816] rcu:     6-....: (5249 ticks this GP) idle=3a4c/1/0x4000000000000000 softirq=6001/6003 fqs=2624
[ 7816.384399] rcu:     (t=5250 jiffies g=29821 q=47 ncpus=8)
[ 7816.386059] CPU: 6 UID: 0 PID: 203 Comm: qemu-system-aar Not tainted 6.15.0-rc1-gavin-g78b23c56de79 #34 PREEMPT
[ 7816.387133] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 02/02/2022
[ 7816.387926] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[ 7816.388678] pc : realm_unmap_private_range+0x19c/0x2c0
[ 7816.389878] lr : realm_unmap_private_range+0x94/0x2c0
[ 7816.390388] sp : ffff80008095bb60
[ 7816.390765] x29: ffff80008095bb60 x28: 000000007caef000 x27: ffffba3322764000
[ 7816.392321] x26: 00007fffffffffff x25: 000000007caf0000 x24: 0001000000000000
[ 7816.393168] x23: 00000000c4000155 x22: ffff8000801b5e98 x21: 0000000106481000
[ 7816.393999] x20: 000000007caef000 x19: 0000000000000000 x18: 0000000000000000
[ 7816.394833] x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffff8e997058
[ 7816.395668] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[ 7816.396548] x11: 0000000038e38e39 x10: 0000000000000004 x9 : ffffba33218a2564
[ 7816.397419] x8 : ffff8000801b5e98 x7 : 000000003fffffff x6 : 0000000000000001
[ 7816.398243] x5 : 000000011e795000 x4 : 0000000000000002 x3 : 0000000000000000
[ 7816.399062] x2 : 000000007caf0000 x1 : 000000011e796000 x0 : 0000000000000000
[ 7816.400021] Call trace:
[ 7816.400604]  realm_unmap_private_range+0x19c/0x2c0 (P)
[ 7816.401347]  kvm_realm_unmap_range+0x94/0xb0
[ 7816.401894]  __unmap_stage2_range+0x70/0xa0
[ 7816.402421]  kvm_arch_post_set_memory_attributes+0x68/0xa8
[ 7816.403011]  kvm_vm_ioctl+0x6bc/0x1b58
[ 7816.403509]  __arm64_sys_ioctl+0xa4/0xe8
[ 7816.404020]  invoke_syscall+0x50/0x120
[ 7816.404562]  el0_svc_common.constprop.0+0x48/0xf0
[ 7816.405113]  do_el0_svc+0x24/0x38
[ 7816.405584]  el0_svc+0x34/0xf0
[ 7816.406045]  el0t_64_sync_handler+0x10c/0x138
[ 7816.406571]  el0t_64_sync+0x1ac/0x1b0

Thanks,
Gavin

