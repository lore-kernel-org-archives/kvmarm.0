Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287DAC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 20:13:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6184B49EFD;
	Wed, 23 Mar 2022 16:13:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0q25LeXTM-Zy; Wed, 23 Mar 2022 16:13:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4482740C1B;
	Wed, 23 Mar 2022 16:13:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B1E940BBF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 16:13:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIzlXP20OpCK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 16:13:38 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14849404FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 16:13:38 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id
 l4-20020a17090a49c400b001c6840df4a3so2993946pjm.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=87pHWuuOeFMvF2m5qztZ+3SsMU0YaX9iK1MT2LhBueA=;
 b=i0dxUGbj8ISDKpsBHPxbsOd7JTE3/LT6oezBVS6Ygw/H9fWokSh4gd5bkwFf/BPoyD
 tDzGiwsddBiPHtxhLGhPFOn0MV7GUVY83bsrHiJI49gXo9Bpe/vfnzxjhI/FAP2yVj0v
 Qj+bKYYF0Qbd7D7EZCx4bzcqvRb9A7zCUrJv0Zj6zKMkOvUjnsSFRA7S/N2bOIuHnPRC
 Cd6lsZdoZLnJlya/JqvEo0lj4HBx5zoAFKPATsBZpsixaO94Jcqb97e/8KwnjLbPmtCQ
 78wzcsMeqUOYIR3ui7b1LgCEMrubpbyqB1VLqscEOiGzIYkMsK090kdy9qWKW2uW7qDp
 OFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=87pHWuuOeFMvF2m5qztZ+3SsMU0YaX9iK1MT2LhBueA=;
 b=Mf8ddmXd9sYOw3tNVVYHCEIFv0M78a6QTcl4DCCJEIFObRXkYetlgDSSiw7CrH0PIR
 hF/Dtm8J8Ll+MEH2GKB1Ipz+XjFRu3CRh2rzfLwwnvTyUiR1ZfhTzwla3u0/1sSmI9tD
 AdgFuBhh5ZO8wPLA604MS6ctUIqXNa4D+r6BilW/gFq7xxBG6ha2pIvjg3vqiJ8SgJvZ
 yqzKJ+pwgUAw9+1Ql+pGzOyZp593f+lxzq1t7aPcw7nZdeC0RXt2l7Gl2uOwjiVQ3Kxs
 ymUNterdAuk1HfeMb/H+35xXH+o3JdhK324A9edEqntveaw2PVMlfBQnr9UpdIcx4N/Z
 liGQ==
X-Gm-Message-State: AOAM530Bg67Cdh0oRQdoaXvRmw2K9A3NAXN9pwOcskNOHkxij6Nf9TDo
 ovioXEy69n8Y9WnzFbuXXXx17Q==
X-Google-Smtp-Source: ABdhPJxW0nWbCs+fKb2VZ7Dp78kvE0grHKXIDDZuoMohOONgFKBhBJ2rsNLjNNxzfGq6158DqpeawQ==
X-Received: by 2002:a17:902:7887:b0:154:4f3f:ec54 with SMTP id
 q7-20020a170902788700b001544f3fec54mr1810342pll.156.1648066416930; 
 Wed, 23 Mar 2022 13:13:36 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 b2-20020a639302000000b003808dc4e133sm505007pge.81.2022.03.23.13.13.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 13:13:36 -0700 (PDT)
Date: Wed, 23 Mar 2022 13:13:32 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjt/bJidLEPsiPfQ@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yjt6qvYliEDqzF9j@google.com>
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

On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > Add hidden or reserved ID registers, and remaining ID registers,
> > which don't require special handling, to id_reg_desc_table.
> > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > or reserved registers. Since now id_reg_desc_init() is called even
> > for hidden/reserved registers, change it to not do anything for them.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> 
> I think there is a very important detail of the series that probably
> should be highlighted. We are only allowing AArch64 feature registers to
> be configurable, right? AArch32 feature registers remain visible with
> their default values passed through to the guest. If you've already
> stated this as a precondition elsewhere then my apologies for the noise.

Aren't AArch64 ID regs architecturally mapped to their AArch32
counterparts?  They should show the same values.  I'm not sure if it's a
problem (and if KVM is faithful to that rule),
> 
> I don't know if adding support for this to AArch32 registers is
> necessarily the right step forward, either. 32 bit support is working
> just fine and IMO its OK to limit new KVM features to AArch64-only so
> long as it doesn't break 32 bit support. Marc of course is the authority
> on that, though :-)
> 
> If for any reason a guest uses a feature present in the AArch32 feature
> register but hidden from the AArch64 register, we could be in a
> particularly difficult position. Especially if we enabled traps based on
> the AArch64 value and UNDEF the guest.
> 
> One hack we could do is skip trap configuration if AArch32 is visible at
> either EL1 or EL0, but that may not be the most elegant solution.
> Otherwise, if we are AArch64-only at every EL then the definition of the
> AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> the problem altogether. What are your thoughts?
> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
