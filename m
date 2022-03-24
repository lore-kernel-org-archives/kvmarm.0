Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F88C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 02:26:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C621740BF0;
	Wed, 23 Mar 2022 22:26:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Bp6H5NW3-Ol; Wed, 23 Mar 2022 22:26:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82BAC49F3E;
	Wed, 23 Mar 2022 22:26:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A7949F35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 22:26:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2NohWxPAUHKV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 22:26:35 -0400 (EDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A691D49F33
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 22:26:35 -0400 (EDT)
Received: by mail-io1-f41.google.com with SMTP id z7so3963295iom.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 19:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=890X9ZlW/q/ZeZqirs7HvcNCWN7aGL7evmsesPaQNmQ=;
 b=rxX998mFFfKKFwyAeeJOshWSPWoXTtcDGc2Rs99n2aE5JPs2wCNBni5DWMWGDK5FKx
 Q7lLIGEqmOvSWff8vXIyOD5ZNt/HCfvrjTYtRVygUmtaS7rEK4hsmBPgiNSjolAwPt9B
 bEcqIk7A9aVcGT6tLAygknW8s63iFNnBVF7O1b6flHzqX0rdAHmWJFaDpNyRrWbESTdW
 w7w3go6IUFDbYKQPt+ig5iHmLmSpZdvceZhiU0rhomRZs+M2kx+IhNEDhVI3yxhdh2hX
 HG8dyKnD5kbiK/15DzoJOKw6fGH74ySt5vJZPCnhT2FsMkINzT7lCURMaC2F4D6EI9AF
 vl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=890X9ZlW/q/ZeZqirs7HvcNCWN7aGL7evmsesPaQNmQ=;
 b=XXefXv/AAyiknL3+OhH3Mfq/X5r7nICYSBPALL+ZmEXKbDS7S/hy41nrOlwDRd+Aq4
 IQPdN/cK2zxmBf1KlV6r40R01sxQ2RWoPZ6ySJHqPAQ58rzyWCgwxXP7kSju3F0X0KcU
 bpCPt38PTXlaqzExmU0Eu2YXBJFSC3jke34KiVDynRV6qOMvs3PH6CnVF1VgVoVIGgNj
 dYQ5GJlodH4i2o6xYMq8G0gTlXNWpgzSoot/CENoAxu3ZbN6ZWW19xC9TjhpexEiKwJg
 2xq/vdsejhfo9CDDwl9mKfHdfEJmd9TVAuE+8Gm/yIkWLhCe6rO8v7Sg51ow61ap6aSP
 wbkA==
X-Gm-Message-State: AOAM532ggHL4LDvJGY286aZBljQLpVuaNQW5cZkAkTnyFh+rwUmdywh2
 J1PhCcH71uWr7LZwu13XlDwyqw==
X-Google-Smtp-Source: ABdhPJwIwB7dsVZCMZPmvWaa1HkqW3/JHdv1qtXXns+LPlUOuyK0nCVpB3hi5nVUva0OPPnhM1Z1Sg==
X-Received: by 2002:a05:6638:3043:b0:314:7ce2:4a6e with SMTP id
 u3-20020a056638304300b003147ce24a6emr1650582jak.258.1648088794648; 
 Wed, 23 Mar 2022 19:26:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 a3-20020a5ec303000000b006496b4dd21csm774433iok.5.2022.03.23.19.26.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 19:26:33 -0700 (PDT)
Date: Thu, 24 Mar 2022 02:26:30 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <YjvW1lLT1sVZf0jK@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com> <Yjt/bJidLEPsiPfQ@google.com>
 <YjuGqunshjhCoIs5@google.com> <Yjuds73S1sO1UpJI@google.com>
 <YjueX2DOxjoc/d4j@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YjueX2DOxjoc/d4j@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Mar 23, 2022 at 10:25:35PM +0000, Oliver Upton wrote:
> On Wed, Mar 23, 2022 at 03:22:43PM -0700, Ricardo Koller wrote:
> > On Wed, Mar 23, 2022 at 08:44:26PM +0000, Oliver Upton wrote:
> > > On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> > > > On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > > > > Hi Reiji,
> > > > > 
> > > > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > > > which don't require special handling, to id_reg_desc_table.
> > > > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > > > for hidden/reserved registers, change it to not do anything for them.
> > > > > > 
> > > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > > 
> > > > > I think there is a very important detail of the series that probably
> > > > > should be highlighted. We are only allowing AArch64 feature registers to
> > > > > be configurable, right? AArch32 feature registers remain visible with
> > > > > their default values passed through to the guest. If you've already
> > > > > stated this as a precondition elsewhere then my apologies for the noise.
> > > > 
> > > > Aren't AArch64 ID regs architecturally mapped to their AArch32
> > > > counterparts?  They should show the same values.  I'm not sure if it's a
> > > > problem (and if KVM is faithful to that rule),
> > > 
> > > I believe it's a bit more subtle than that. The AArch32 feature registers
> > > are architecturally mapped to certain encodings accessible from AArch64.
> > > For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
> > > map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
> > > AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
> > > AArch32 with the MRC instruction. KVM just so happens to handle both of
> > > these reads from the same sys_reg_desc.

Ughhhhh.

We actually clear HCR_EL2.TID3 for AArch32 guests, so AArch32 EL1 reads
straight from hardware. Considering the work we put in to make sure
feature registers are consistent system-wide and the limitations on
certain features, this is plain wrong.

I have a series that addresses this but need to go find some 32 bit
hardware to test with :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
