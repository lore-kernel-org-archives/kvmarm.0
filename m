Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23379ECAA24
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 16:55:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 792324EA8B;
	Thu, 25 Aug 2022 12:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bnxh7NDh0SkQ; Thu, 25 Aug 2022 12:55:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E9C4EA90;
	Thu, 25 Aug 2022 12:55:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5AD24EA8D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 12:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DRuaIcsJBIs2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 12:55:42 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BDC14EA8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 12:55:42 -0400 (EDT)
Date: Thu, 25 Aug 2022 09:55:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661446541;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9PfudzHyIjixtFNm5kgg7UxDCq4e85X2Ko7C0v0c3ck=;
 b=h/i5/9locmY84qikMVi6UMBRsAO2h+115nn8A9ZwnwU0o/1tsyPJ46EuWAw2DZjp0JqAIB
 /gKE0uBk0AEeN8SkUSMhech2DK6BKlwecNaPdOCFj4fAQf4+RTmBCSUgP1hbVEGbzmJTnU
 vmlz/ELltbeY/1diG1mklx0iHrjIKtY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
Message-ID: <Ywepg6c4FT7DvJ83@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-4-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-4-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> Remove the hard-coded {break,watch}point #0 from the guest_code()
> in debug-exceptions to allow {break,watch}point number to be
> specified.  Subsequent patches will add test cases for non-zero
> {break,watch}points.

Also worth mentioning that you're opportunistically zeroing the debug
registers as their values are UNKNOWN out of reset.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
