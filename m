Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8AEC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 19:53:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9588A49F1C;
	Wed, 23 Mar 2022 15:53:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qj0+f6-pMlS9; Wed, 23 Mar 2022 15:53:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 827BA49EEE;
	Wed, 23 Mar 2022 15:53:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4934B49EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:53:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KMVioCRI7339 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 15:53:19 -0400 (EDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39B6A49EED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:53:19 -0400 (EDT)
Received: by mail-io1-f50.google.com with SMTP id e22so3004320ioe.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 12:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ey05sTiU2qlbU8kwj/4AtdgsovBnPHqmS42nG0aXPe4=;
 b=C2XX3ptmp7iD/+L38rLxHCKv+MC7cTKYynD9R0G3uf6eM4YjbyAcAwIKKKOS9Nm88f
 bkipYfhoLP1iaiyF07cmrsDtij8od+icgukWGgOIgW6V6KNE+6oC3iXxwWIiKZWKvrWv
 3kVr1Uau4ONlunHm7FW+YwqMFgGRR/o1+/Vrcs2aJYbDXuUqMkjJEi35MBh6xSrDwEIQ
 778SU1hchiQfPS/HEUuhYR1iA/ABf0VNQoVfg/emOUH0GQykvdLbv3sPlyLPruRHHicp
 ulgCKWw2Lmb5/Zu5M5staLb7/oEhxbk7LYIKpPpp9OtQNUot2GYewoUUoumCvNa0knWP
 c0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ey05sTiU2qlbU8kwj/4AtdgsovBnPHqmS42nG0aXPe4=;
 b=MFns+tamcXIyBSo+NOeMZGot9CdSsEJZe3z+BWaEYAJ+OTUxPXDqACApf/ilOqvE76
 a9vAD23H9FUS14lhqeTjK+F6OR74SntkWLC/QmZd7JGj+AXM01iVet3eFx5AcRzxf2Rc
 /SZKV2wvyNfIwam9kZIT8FrkWbMNIVFRzF8/rq2TYM4p1Lkz2PV4GAXm2z7TP7ymqTvM
 glNC5KkiyJTJIu8jUO+mR8XBg4rWNJ/C0ySa3QnycgXaJU8YEZw9VV2kINHuxOdGH4Wx
 jpSM+LqHUbkGZ/Mh+NdUmcjyk1Eu1wz5hVTkA2ZsOxo3N5uifFI8HcddPyDk98JmdiZV
 6YPw==
X-Gm-Message-State: AOAM530qlDNASnJhTGWp5ckW/k7Xsp6rzUfpjNBVZFtgTXlls4GITFaH
 t2DWGlMFE8o3S/RxaSYpfsDuZw==
X-Google-Smtp-Source: ABdhPJzUI0F5LFrmcE14GaFF3gmoKkkqu/VNMiQEZebQz2uN4fibQPYY9LvuU7HinRZJngUIkr4wZA==
X-Received: by 2002:a05:6638:460d:b0:31a:7b70:e1b6 with SMTP id
 bw13-20020a056638460d00b0031a7b70e1b6mr797194jab.141.1648065198317; 
 Wed, 23 Mar 2022 12:53:18 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 a3-20020a5ec303000000b006496b4dd21csm378009iok.5.2022.03.23.12.53.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 12:53:17 -0700 (PDT)
Date: Wed, 23 Mar 2022 19:53:14 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjt6qvYliEDqzF9j@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220311044811.1980336-12-reijiw@google.com>
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

Hi Reiji,

On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> Add hidden or reserved ID registers, and remaining ID registers,
> which don't require special handling, to id_reg_desc_table.
> Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> or reserved registers. Since now id_reg_desc_init() is called even
> for hidden/reserved registers, change it to not do anything for them.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

I think there is a very important detail of the series that probably
should be highlighted. We are only allowing AArch64 feature registers to
be configurable, right? AArch32 feature registers remain visible with
their default values passed through to the guest. If you've already
stated this as a precondition elsewhere then my apologies for the noise.

I don't know if adding support for this to AArch32 registers is
necessarily the right step forward, either. 32 bit support is working
just fine and IMO its OK to limit new KVM features to AArch64-only so
long as it doesn't break 32 bit support. Marc of course is the authority
on that, though :-)

If for any reason a guest uses a feature present in the AArch32 feature
register but hidden from the AArch64 register, we could be in a
particularly difficult position. Especially if we enabled traps based on
the AArch64 value and UNDEF the guest.

One hack we could do is skip trap configuration if AArch32 is visible at
either EL1 or EL0, but that may not be the most elegant solution.
Otherwise, if we are AArch64-only at every EL then the definition of the
AArch32 feature registers is architecturally UNKNOWN, so we can dodge
the problem altogether. What are your thoughts?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
