Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DB1CCA47E
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 18:45:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCF5C4B1B4;
	Thu, 16 Jun 2022 14:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 66lpezC+ij5U; Thu, 16 Jun 2022 14:44:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C0464B121;
	Thu, 16 Jun 2022 14:44:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 943404B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:44:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXSWorBkm3Bp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 14:44:56 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42D164B103
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:44:56 -0400 (EDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1655405094;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Vyq1QaJNcPGeZXUPChWIIfLLby0vd/A5lJq5m22MfDI=;
 b=F77myjhPBWu0h7ouFKKj0XC9PilN0M7a9ouW2YaFoSXdgN8CVJ+CDau2RV6XCwtnnBluRB
 ayIgk0cX5PRFYRmiToLFeK4mXWHDK2B5vHwt7UBftBK/BrEqJCGKICgjanti1ZbxByX7Lp
 ULHroYgZFgfrGwnb1buKFIR5ktUxAfo=
Date: Thu, 16 Jun 2022 18:44:53 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: oliver.upton@linux.dev
Message-ID: <7b1040c48bc9b2986798322c336660ab@linux.dev>
Subject: Re: [PATCH] selftests: KVM: Handle compiler optimizations in
 ucall
To: "David Laight" <David.Laight@aculab.com>
In-Reply-To: <3e73cb07968d4c92b797781b037c2d45@AcuMS.aculab.com>
References: <3e73cb07968d4c92b797781b037c2d45@AcuMS.aculab.com>
 <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
 <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
 <20220616162557.55bopzfa6glusuh5@gator>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Colton Lewis <coltonlewis@google.com>, linux-kselftest@vger.kernel.org,
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

June 16, 2022 11:48 AM, "David Laight" <David.Laight@aculab.com> wrote:
> No wonder I was confused.
> It's not surprising the compiler optimises it all away.
> 
> It doesn't seem right to be 'abusing' WRITE_ONCE() here.
> Just adding barrier() should be enough and much more descriptive.

I had the same thought, although I do not believe barrier() is sufficient
on its own. barrier_data() with a pointer to uc passed through
is required to keep clang from eliminating the dead store.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
