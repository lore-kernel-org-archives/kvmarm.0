Return-Path: <SRS0=IXmk=NP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CA3C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 21:15:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AEB6761357
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 21:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AEB6761357
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2572C4B25D;
	Tue, 24 Aug 2021 17:15:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ls3KE6+5y66D; Tue, 24 Aug 2021 17:15:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 114F24B168;
	Tue, 24 Aug 2021 17:15:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 468404B168
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 17:15:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kfoZKfmL4Qy2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Aug 2021 17:15:10 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BC584B13A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 17:15:10 -0400 (EDT)
Received: by mail-il1-f170.google.com with SMTP id v2so21881699ilg.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 14:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
 bh=ahx89PC8cIKRx7Tmgj3ezIoGMxGJS6rYJPfdg8hea3I=;
 b=Blewoeg8VpEAOSLu2fSVu1OYBII8wSOT80G8mkJfn17EhHJTy8t0VNwi1CMA35qzJH
 PRNMksekGBMvfEDa3qJe36pT4LdGCE1FTxqod0mR6XTiXTCpxXoj2DP+T3e1Oru5MOM+
 SeTcPAMWPYLnbKsWsLQAoBsq+L6rzQVil6UYcvCVGis77NysmIW+IIDOCT9829zPy+ZM
 HNSI4par/xzky/hnonF2H6lYrlRgUfMLLTvc5agLCJSH3L8ooyfq+b7JZRgqLbrSBTlT
 VR1NetWEkKhWRrdPCcXEAo3AFp8CsjP+AWP/HzqUmOPxnNQojfwhKj62gyWzJC0/tDlZ
 EkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=ahx89PC8cIKRx7Tmgj3ezIoGMxGJS6rYJPfdg8hea3I=;
 b=g6tpEWK4sszTWn6sJvjrgqLF0y5laUTV4FlX8NL6e5R69CmxWOMtcCsa43AuKfaqXj
 jijemxjWL4LOcaWW4loyQlLWU4ITmcmxXbXXZSncOi3MRSiicpAg08jDn44Q02vWkEUO
 G6uhRKabfpUNiln5ssTkPzYFGSGecK9irgZ2HvGefrvkveFMHsYZMdD/CZrwt9Ysrvpn
 /xGX6RIFCAL2PDxBRZ7j7zi0osiis9Q7IvdUn+0MRxpq31nKRe2v1N7takw0pykJbcvb
 LZEYJK2omTQupLsOsKHZDB0X6B7t5R5ea8aIXnnpbGFyXyOldor9oLi3GkNi04eOG6M8
 Fupg==
X-Gm-Message-State: AOAM530FQj0vEo+L5Zh5pCwhj8gTIbEG8sUO0eq1xqaVD+v2diqTqcOw
 gMyRivzu3sVUWw+1E0bD3SldXQtIjl9TOA==
X-Google-Smtp-Source: ABdhPJzYkTLe3JL/GRn7dx88lWcWUrTlT/x7EdbbtUTbRMUsj0b7GHuF0etxTSoOuXH25YUqoAlx3g==
X-Received: by 2002:a92:d282:: with SMTP id p2mr24901934ilp.259.1629839709100; 
 Tue, 24 Aug 2021 14:15:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id z7sm10585059ilz.25.2021.08.24.14.15.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Aug 2021 14:15:08 -0700 (PDT)
Date: Tue, 24 Aug 2021 21:15:03 +0000
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <YSVhV+UIMY12u2PW@google.com>
MIME-Version: 1.0
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
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

Hey folks,

Ricardo and I were discussing hypercall support in KVM/arm64 and
something seems to be a bit problematic. I do not see anywhere that KVM
requires opt-in from the VMM to expose new hypercalls to the guest. To
name a few, the TRNG and KVM PTP hypercalls are unconditionally provided
to the guest.

Exposing new hypercalls to guests in this manner seems very unsafe to
me. Suppose an operator is trying to upgrade from kernel N to kernel
N+1, which brings in the new 'widget' hypercall. Guests are live
migrated onto the N+1 kernel, but the operator finds a defect that
warrants a kernel rollback. VMs are then migrated from kernel N+1 -> N.
Any guests that discovered the 'widget' hypercall are likely going to
get fussy _very_ quickly on the old kernel.

Really, we need to ensure that the exposed guest ABI is
backwards-compatible. Running a VMM that is blissfully unaware of the
'widget' hypercall should not implicitly expose it to its guest on a new
kernel.

This conversation was in the context of devising a new UAPI that allows
VMMs to trap hypercalls to userspace. While such an interface would
easily work around the issue, the onus of ABI compatibility lies with
the kernel.

So, this is all a long-winded way of asking: how do we dig ourselves out
of this situation, and how to we avoid it happening again in the future?
I believe the answer to both is to have new VM capabilities for sets of
hypercalls exposed to the guest. Unfortunately, the unconditional
exposure of TRNG and PTP hypercalls is ABI now, so we'd have to provide
an opt-out at this point. For anything new, require opt-in from the VMM
before we give it to the guest.

Have I missed something blatantly obvious, or do others see this as an
issue as well? I'll reply with an example of adding opt-out for PTP.
I'm sure other hypercalls could be handled similarly.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
