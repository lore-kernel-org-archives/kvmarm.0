Return-Path: <SRS0=pHiG=XO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27B4C4CECE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 00:23:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48942218AE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 00:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="R3NvO9RH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48942218AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F3B54A67D;
	Wed, 18 Sep 2019 20:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ozlabs.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IpC1orvUbgs6; Wed, 18 Sep 2019 20:23:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6EB54A67A;
	Wed, 18 Sep 2019 20:23:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53104A67B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Sep 2019 20:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tLyq4TlooYS7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Sep 2019 20:23:38 -0400 (EDT)
Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2E084A679
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Sep 2019 20:23:37 -0400 (EDT)
Received: by ozlabs.org (Postfix, from userid 1003)
 id 46YcyX6FPFz9sNF; Thu, 19 Sep 2019 10:23:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
 t=1568852612; bh=cw3bVSIKyGLl8fd6W8ykuEcHQm9lvtEQ4ISh1Suv21A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=R3NvO9RHRrBeHenKeGVQwRwaNzl90QJKU91Oh5UtKsnjPccYcuWsO/+sjMOyqwX7L
 qXGlMsp052mihy0ZJJ2eIVJLqlRGa9kQM/LgVKA7ED5dZy2xxDU0F7hWJ5Tp54i1Oj
 k55td7N92nS1j9aJa2rikaxwZ/Rett3ejrVCl2Y6XgJzt/d7qDn+ismHBncyRTAYV+
 hS8OCe+151b9IycINykjKDkPYC/8MG9vZUkPbnlESnKeZ09ZuP4shL0f/tklBl/8Uc
 RZALg8LGgjsbVJ+XmBlldREITO6j39TWleHK6T7JSCMg1LLpCOuW1Dvvlzw9Z/mO8v
 uxbb98hT109Jg==
Date: Thu, 19 Sep 2019 10:23:28 +1000
From: Paul Mackerras <paulus@ozlabs.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 02/13] KVM: PPC: Move memslot memory allocation into
 prepare_memory_region()
Message-ID: <20190919002328.GB19503@blackberry>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190911185038.24341-3-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Wed, Sep 11, 2019 at 11:50:27AM -0700, Sean Christopherson wrote:
> Allocate the rmap array during kvm_arch_prepare_memory_region() to pave
> the way for removing kvm_arch_create_memslot() altogether.  Moving PPC's
> memory allocation only changes the order of kernel memory allocations
> between PPC and common KVM code.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Seems OK.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
