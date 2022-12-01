Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691FDC43217
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 17:26:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EE740399;
	Thu,  1 Dec 2022 12:26:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jw-UBjPivIFL; Thu,  1 Dec 2022 12:26:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DDC6403C2;
	Thu,  1 Dec 2022 12:26:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C4CE4076C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 12:26:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nULJepQxVNk5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 12:26:14 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08317403C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 12:26:13 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 b13-20020a17090a5a0d00b0021906102d05so2735549pjd.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 09:26:13 -0800 (PST)
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
 b=lJQHvAp0jckuM5gnN9n6psW/rY2IfuzUqkIa2+vARFcWodPm/XcNTT15v/AY6aAmbr
 dO7TdLo3OmzXuZ2xfk33RMqz1amj/TT5wywQ3qkaIy/2gdnyJ+nM1ZsuWzwTDHj6wL8c
 iPZM0SPnMSKjuObHG5HfPjS1Cj8Mr++ejYz5RViChQQlxWmBh7EbtehCRs/58wOPr+6o
 VHNahNb7sCssTF2BQJ+ptYyCGwzxxmorK+3+q33DhYRxCgcbzr8twHQCFq+Pz1REukiC
 51Y1am23bnx7ja0wAlqg3LsnLRJ9aTaV9O4R8Gxz5BLLrqlfFxV3G2CKhhJeOA2ELm0E
 Yp+w==
X-Gm-Message-State: ANoB5pmSZYvtcGoSHxIALPLkiayvGM58Afk28h8xuvZ00gyENBSXV+Rx
 5N6VpJ4Ku8mAtkI9PwWN7/TtTg==
X-Google-Smtp-Source: AA0mqf4SMFdu/n4a1aFlo3szQD2bjOfheoqlSHE9xuODUTMXDUAclzarx3ixXW8iNFKhgeVWojv9Lg==
X-Received: by 2002:a17:902:d650:b0:189:f86:ecb with SMTP id
 y16-20020a170902d65000b001890f860ecbmr58839022plh.45.1669915572825; 
 Thu, 01 Dec 2022 09:26:12 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419?
 ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 n11-20020a170902e54b00b00178aaf6247bsm3965798plf.21.2022.12.01.09.26.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 01 Dec 2022 09:26:12 -0800 (PST)
Message-ID: <50499ee9-33fe-4f5d-9d0a-76ceef038333@daynix.com>
Date: Fri, 2 Dec 2022 02:26:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
To: Marc Zyngier <maz@kernel.org>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <867czbmlh1.wl-maz@kernel.org>
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
