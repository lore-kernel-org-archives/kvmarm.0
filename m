Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC38C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 14 Dec 2022 09:43:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1981B4B973;
	Wed, 14 Dec 2022 04:43:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nNQBUpnDc6AA; Wed, 14 Dec 2022 04:43:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C87D34B96A;
	Wed, 14 Dec 2022 04:43:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D79B34B966
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 04:43:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScWruytlmmdw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2022 04:43:17 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1A414B965
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 04:43:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id AAFF16189A;
 Wed, 14 Dec 2022 09:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BDAC433EF;
 Wed, 14 Dec 2022 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671010996;
 bh=uut+hV+py5emy6howSBFzXtArJVZljieADDyI0cWYpo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=cPLmhgJKLNx4gsb0xlxx3yfRK1F7tY1cR6GGJ9ucvTrjU8d7XbVcWxz9sj4nz76pn
 3XWCoQhtzjzJg0NF0942XNAGNKnWLlwARVvkb5nGW99BbAwsVKs1HSxvNsfLNewdJr
 fOu545yq7Ho1HliIFRi8gkhBXysWBWGWk1qwNKoYTs8v2Bz1T3FYVAywCKIs24nBZf
 aMYQT3vivDNLhoG7WiRBdEooKYCTz47hbRPwdXZdN0uh5xgrP8ij1CUNdkoPd4CBOR
 dLgWp/6xBbV+ByOIeXM0E0dBYiNf3Jl3s+W9tS1GZGUNRizztiScmuN9fn615e3zcG
 vCApSYl6i7FbA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p5OID-00CZta-P7;
 Wed, 14 Dec 2022 09:43:13 +0000
MIME-Version: 1.0
Date: Wed, 14 Dec 2022 09:43:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 06/14] KVM: selftests: Rename UNAME_M to ARCH_DIR, fill
 explicitly for x86
In-Reply-To: <Y5jadzKz6Qi9MiI9@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-7-seanjc@google.com> <Y5jadzKz6Qi9MiI9@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <edd6f54afb8c6e8e83d57d3c9162ecbd@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: seanjc@google.com, pbonzini@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 nathan@kernel.org, ndesaulniers@google.com, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
 trix@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, ricarkol@google.com, aaronlewis@google.com,
 rananta@google.com, dmatlack@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Tom Rix <trix@redhat.com>, llvm@lists.linux.dev,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Aaron Lewis <aaronlewis@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

On 2022-12-13 20:03, Sean Christopherson wrote:

> One last thought/question, what do y'all think about renaming 
> directories to
> follow the kernel proper?  I.e. aarch64=>arm64, s390x=>s390, and 
> x86_64=>x86.
> Then $(ARCH_DIR) would go away.  The churn would be unfortunate, but it 
> would be
> nice to align with arch/ and tools/arch/.

aarch64->arm64 makes sense to me. Whether it is worth the churn
is another question. As long as we don't try to backport tests,
the damage should be limited to a single merge window.

           M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
