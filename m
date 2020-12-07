Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07C6C4361B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 13:54:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42BCB235E4
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 13:54:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42BCB235E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3FED4B22D;
	Mon,  7 Dec 2020 08:54:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZFe3U9WDc9bu; Mon,  7 Dec 2020 08:54:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97CF74B28C;
	Mon,  7 Dec 2020 08:54:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEB084B246
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 08:54:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zipOS1RcYNC7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 08:54:52 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F31D4B22D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 08:54:52 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 33FD4235DD;
 Mon,  7 Dec 2020 13:54:51 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kmGyW-00Gm6K-SB; Mon, 07 Dec 2020 13:54:49 +0000
MIME-Version: 1.0
Date: Mon, 07 Dec 2020 13:54:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
In-Reply-To: <X84Y07kbeSL4xcNJ@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
 <X8p5kLSIq2MoQZ24@google.com>
 <CA+EHjTxW_z-P8bK7gCjGv2eBCAHFsvE873Gr2KyVq5-+_Mdv=g@mail.gmail.com>
 <X84Y07kbeSL4xcNJ@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d6a674a0e8e259161ab741d78924c756@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, tabba@google.com,
 catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robh+dt@kernel.org,
 frowand.list@gmail.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: "moderated list:ARM64 PORT \(AARCH64
 ARCHITECTURE\)" <linux-arm-kernel@lists.infradead.org>,
 "open list:OPEN FIRMWARE AND
 FLATTENED DEVICE TREE" <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64
 \(KVM/arm64\)" <kvmarm@lists.cs.columbia.edu>
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

On 2020-12-07 11:58, Quentin Perret wrote:
> On Monday 07 Dec 2020 at 11:16:05 (+0000), Fuad Tabba wrote:
>> On Fri, Dec 4, 2020 at 6:01 PM Quentin Perret <qperret@google.com> 
>> wrote:
>> >
>> > On Thursday 03 Dec 2020 at 12:57:33 (+0000), Fuad Tabba wrote:
>> > <snip>
>> > > > +int hyp_create_idmap(void);
>> > > > +int hyp_map_vectors(void);
>> > > > +int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
>> > > > +int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
>> > > > +int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
>> > > > +int __hyp_create_mappings(unsigned long start, unsigned long size,
>> > > > +                         unsigned long phys, unsigned long prot);
>> > > > +unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
>> > > > +                                          unsigned long prot);
>> > > > +
>> > >
>> > > nit: I also thought that the hyp_create_mappings function names are a
>> > > bit confusing, since there's the create_hyp_mappings functions which
>> > > use the aforementioned *hyp_pgtable.
>> >
>> > Sure, happy to re-name those (and hyp_pgtable above). Any suggestions?
>> 
>> Perhaps something to indicate that these are temporary, tmp_ or
>> bootstrap_ maybe?
> 
> Hmm, the thing is these are temporary only in protected mode, they're
> permanent otherwise :/
> 
> Perhaps I could prefix the protected pgtable (and associated functions)
> with 'pkvm_' or so? Marc, any preferences?

None. Whichever name you pick, someone will ask you to change it.
Just call it Bob.

What I really *don't* want is see a blanket rename of existing symbols
or concepts.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
