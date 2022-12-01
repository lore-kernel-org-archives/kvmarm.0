Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731D87473
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 17:26:13 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso4572602pjb.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Dec 2022 09:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=02CF0TJYI4L7g3srrazD4xH+/OuBD9klT/4Hk2gtU0U=;
        b=txApKc3gtDcQMm+FVBYm+D0Mo1n4TL0Vapxd3lQf0wekHKp4QFL/juRdq0ivkrC709
         rVw0C5ACxYCPAbySn7V5JKA+NV3okQWkwPGbENM2SJwgdMTeyObxCCwgwUOOx0BC7oWz
         +h7qGkFumy1Mw737V/jWWIQ0z6+NFFhlD5owjCq/feMugXvEoCHJax5uCjFKdA88ptVQ
         C2bNboHdjpx/p+BBKcMcghLfjGguL5CJ+usVgzk6pHX7s0eXXjYbXywS0/ciUiAkhj6B
         w4jY4IdmFe2vSaYLG2oj5UHN9K1ZzirLTvOs3K1gjqpLYDePd8bzLoi1/rndXhowE6SL
         zdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=02CF0TJYI4L7g3srrazD4xH+/OuBD9klT/4Hk2gtU0U=;
        b=g50o0ELkSgwSKBDJPciDCQEZOT9g9LvvCNFPutRNZfjtCPrlu6q8T+/6aDNW5BpCcD
         wiQrwcxi85ESrXaU+zgN9RLBPEr8EFtV/IMVp5jyGtnxKVzxNfWHvcQai26ofPxbUjrM
         oGnTcKESCvExpDpKYWJcFELgAKcNQFAO7/y3DnNduizA3lRL4xifYHiYKzyvkhNvaFPl
         QKtOfIBy7r7oQ2ipxfBH22LYh1FtE3Vcnr2IpEXwWPUrGdU9b/lF9X+fWrl0Ib+9qNIk
         a0gQc3IU4GOxs76gLo8ALD4fD2PPS4tkbw8GXvE1wfTEuFGjAImtcway10hB/2j23hh5
         8/RQ==
X-Gm-Message-State: ANoB5pm8sFGaMNXSEmQyDSfTnxH0nQe52jkmNQMpFyOBhHWa0qEcAMCY
	sBK0MIxr4gCwW2/jhX0xYOQRUw==
X-Google-Smtp-Source: AA0mqf4SMFdu/n4a1aFlo3szQD2bjOfheoqlSHE9xuODUTMXDUAclzarx3ixXW8iNFKhgeVWojv9Lg==
X-Received: by 2002:a17:902:d650:b0:189:f86:ecb with SMTP id y16-20020a170902d65000b001890f860ecbmr58839022plh.45.1669915572825;
        Thu, 01 Dec 2022 09:26:12 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902e54b00b00178aaf6247bsm3965798plf.21.2022.12.01.09.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:26:12 -0800 (PST)
Message-ID: <50499ee9-33fe-4f5d-9d0a-76ceef038333@daynix.com>
Date: Fri, 2 Dec 2022 02:26:08 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter <sven@svenpeter.dev>,
 Hector Martin <marcan@marcan.st>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <867czbmlh1.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221201172608.CV0Ywjwd_mp-2XJKjiyq365dGsIdZYTCokqSixlIIUs@z>

On 2022/12/01 20:06, Marc Zyngier wrote:
> On Thu, 01 Dec 2022 10:49:11 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> 
> Thanks for looking into this.
> 
>> M2 MacBook Air has mismatched CCSIDR associativity bits, which makes the
>> bits a KVM vCPU sees inconsistent when migrating.
> 
> Can you describe the actual discrepancy? Is that an issue between the
> two core types? In which case, nothing says that these two cluster
> should have the same cache topology.

Yes, the processor has big.LITTLE configuration.

On the processor, the valid CSSELR values are 0 (L1D), 1 (L1I), 3 (L2D). 
For each CSSELR values, each cluster has:
- 0x700FE03A, 0x203FE01A, 0x70FFE07B
- 0x701FE03A, 0x203FE02A, 0x73FFE07B

> 
>> It also makes QEMU fail restoring the vCPU registers because QEMU saves
>> and restores all of the registers including CCSIDRs, and if the vCPU
>> migrated among physical CPUs between saving and restoring, it tries to
>> restore CCSIDR values that mismatch with the current physical CPU, which
>> causes EFAULT.
> 
> Well, QEMU will have plenty of other problems, starting with MIDRs,
> which always reflect the physical one. In general, KVM isn't well
> geared for VMs spanning multiple CPU types. It is improving, but there
> is a long way to go.

On M2 MacBook Air, I have seen no other difference in standard ID 
registers and CCSIDRs are exceptions. Perhaps Apple designed this way so 
that macOS's Hypervisor can freely migrate vCPU, but I can't assure that 
without more analysis. This is still enough to migrate vCPU running 
Linux at least.

> 
>> Trap CCSIDRs if there are CCSIDR value msimatches, and override the
>> associativity bits when handling the trap.
> 
> TBH, I'd rather we stop reporting this stuff altogether.
> 
> There is nothing a correctly written arm64 guest should do with any of
> this (this is only useful for set/way CMOs, which non-secure SW should
> never issue). It would be a lot better to expose a virtual topology
> (one set, one way, one level). It would also save us from the CCSIDRX
> silliness.
> 
> The only complexity would be to still accept different topologies from
> userspace so that we can restore a VM saved before this virtual
> topology.

Another (minor) concern is that trapping relevant registers may cost too 
much. Currently KVM traps CSSELR and CCSIDR accesses with HCR_TID2, but 
HCR_TID2 also affects CTR_EL0. Although I'm not sure if the register is 
referred frequently, Arm introduced FEAT_EVT to trap CSSELR and CSSIDR 
but not CTR_EL0 so there may be some case where trapping CTR_EL0 is not 
tolerated. Perhaps Arm worried that a userspace application may read 
CTR_EL0 frequently.

If you think the concern on VM restoration you mentioned and the 
trapping overhead is tolerable, I'll write a new, much smaller patch 
accordingly.

Regards,
Akihiko Odaki

> 
> Do you mind having a look at this?
> 
> Thanks,
> 
> 	M.
> 
