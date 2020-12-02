Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786BCC64E7B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 15:44:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC9E320B1F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 15:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC9E320B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03CB54B33A;
	Wed,  2 Dec 2020 10:44:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c+3Oeqxgp-Wi; Wed,  2 Dec 2020 10:44:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11CC44B351;
	Wed,  2 Dec 2020 10:44:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B02D94B33E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 10:44:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ICoETzQcm32V for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 10:44:39 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5C934B33A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 10:44:39 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id h21so9386032wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 07:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/UHxwpIgzVzreRL98GaE+Nf+yyIwRliZkCO7QwUCEgs=;
 b=gp6qawBNxj20UMCB0qKbqw35Nh7dgu1epXjabfxPkvif2E6O8pV9qsix7Swhk16rgA
 7U8GXJzUXnwfKVqYUjOLrtRQrSChgE7vZnpjBYWcRpilLM2szXRG69gSh5qpxe+GDMQ9
 KDwdufKg3mdvIsTbFSBlskjEK0inIAModCfOxYOJpbqCX4Nt9eX7sJN2jICQ5ByfPXTx
 629pV2SxxiGkQCnmoA6E0i5XXYqDAJ3dQVWYMse12jjHf8G5E/9mMCEcUCiMne2eCFIS
 97aq1mVCe4qraq5zC1HtXSTmf47MvJ2/dkbIQdZ2PEPjc9OFMWBuVoSbVniM6Z9RX8/T
 sOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/UHxwpIgzVzreRL98GaE+Nf+yyIwRliZkCO7QwUCEgs=;
 b=g/xKdqEf65eK7+WsM1DUyeS4/98+6vvshkXxphSCk5fDT3aKjXysI7i1fwdt43bVT1
 vmQRoxAdn682xG3dNNnlpiwUUlFfN7h9DaCcWAORsUZHuCfEVNAdESug6eCMvYcmRa/t
 ApgbCOvtsuzYY1ArPGXqF9NisqX9MHRCEESs9nsq3ZViQ0ZrTgPMBSVsffLy+pbOA79a
 yq5itHjRn/H+nU65HTABgsIPul1nTzC8BsZPEUrApGAv300I+M+/w66xGTbL+LZnjBTV
 2X2NpXM1FkfkfoBsCchuotgHuDzZBZOMZhO0Ilqhy1BD0KuRqTWLEYid1Fujh2qCv9fC
 mEmw==
X-Gm-Message-State: AOAM532ZX1dzzZtdheFdinw8SxHrHE8EnKkICYn5W+/yyDKsAJxhHR3Y
 ET6sv5yeW57seWgPqjNs6N8qUQ==
X-Google-Smtp-Source: ABdhPJzjZbg91HBzD7xhdNYxZfeVt0A22RkKuj4c+xnN4xgU/POWZiYJcdkezzLJU++VssNAnOmuew==
X-Received: by 2002:a1c:ddd5:: with SMTP id u204mr3724239wmg.174.1606923878152; 
 Wed, 02 Dec 2020 07:44:38 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id y7sm2620731wrp.3.2020.12.02.07.44.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Dec 2020 07:44:37 -0800 (PST)
Date: Wed, 2 Dec 2020 15:44:35 +0000
From: David Brazdil <dbrazdil@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 03/23] arm64: Make cpu_logical_map() take unsigned int
Message-ID: <20201202154435.qpr7ow53xra3xjkd@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-4-dbrazdil@google.com>
 <20201126172838.GD38486@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126172838.GD38486@C02TD0UTHF1T.local>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, Nov 26, 2020 at 05:28:38PM +0000, Mark Rutland wrote:
> On Thu, Nov 26, 2020 at 03:54:01PM +0000, David Brazdil wrote:
> > CPU index should never be negative. Change the signature of
> > (set_)cpu_logical_map to take an unsigned int.
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> 
> Is there a function problem here, or is this just cleanup from
> inspection?
> 
> Core code including the cpuhp_*() callbacks uses an int, so if there's a
> strong justification to change this, it suggests there's some treewide
> cleanup that should be done.
> 
> I don't have strong feelings on the matter, but I'd like to understand
> the rationale.

Yeah, it's a mess. Marc and I felt that using a uint was less error-prone wrt
bounds checks. If this gets an int, it still works and only checking the upper
bound is required. Does that make sense?

David

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
