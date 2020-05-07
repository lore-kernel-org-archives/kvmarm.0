Return-Path: <SRS0=Tpw5=6V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991EEC38A2A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 15:13:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 23E862063A
	for <kvmarm@archiver.kernel.org>; Thu,  7 May 2020 15:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KTP/UuKn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E862063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBACB4B3D8;
	Thu,  7 May 2020 11:13:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fVy5kjgIPyul; Thu,  7 May 2020 11:13:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA68C4B274;
	Thu,  7 May 2020 11:13:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 619F14B274
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 11:13:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgFzaFzPOTLz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 11:13:28 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BB914B24E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 11:13:28 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id h9so6862712wrt.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2020 08:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=S2uo98FwAjVg5CWP5Av+uIlNFRj0bTJ/Soj3by7c/U4=;
 b=KTP/UuKnmFq2SPCo2FGyvoGogXVtgtFTX5B4pJ8o/uSdf2i17qIMcFtyhsPPurcepl
 TbE5Rgj3LKq1EPMC9Co4rtvTM66GKJ56TWPuka3aSQqzUCOVcYjbiDExz6JDELbOQDAG
 wSB2FwSYtEWaFVYj6juw+K/c+6PgofSbKHcoRnalTJBpuFTSlfwRcSjqHzZbRpKqboFw
 tMOt470dTW4GQir+16tCiljhjjBZt3GqcbkmGJGPM2qE2G50yC2baZINqrYNUQCpWGYq
 CLuFbuEi3wSxnL0lNFoOAgCyVRtv1Fr1W/+sFw0ohgtjSiGprk1+wysg1+kwJ37SpF32
 Ocaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=S2uo98FwAjVg5CWP5Av+uIlNFRj0bTJ/Soj3by7c/U4=;
 b=Ouz7bNsNB2GnA/yCy5lHr1+7pLxjF0eZBEdxvs0FkQEwHL8HVGxYdaUaFNL8a3JfeL
 8G7amF9UIkiigngB3tZiw1W381QiLHy5N9XeSny3S06svlTXFLBaUsMTfuravYnlpsD+
 RpBbF94P2jyz6fX5MauyWMBIiD8+kDgjIV1mt1JR35xnkgYxb7H76yRgsQ2K/PkxVUk4
 Qwc2Olf+1sKydgxQtvCw8/Vhp/Py50t+xkXOrmpuoMgktno/T3yV/fH1l2I3fb92GRzn
 u766FtTPxnhVCujn56MGufwIA3eKXWIJbRkjQDuuo7U2I+Y4Q8Y0iaQawoy3KqtgsSMh
 kJig==
X-Gm-Message-State: AGi0PubpXFrBMXsao6+zholLhz/4wCPWxlGCmA+pSzZUPA6l51ZKhnaj
 xV/zGnKamy+7PF9QP+UN1RimGQ==
X-Google-Smtp-Source: APiQypLNfmFFEmEkdVcn8CcdE0QmpbeyzViDZ82NLnSF0CRXgetg8FYsnaOyp6ozrpX3U1nd3rIVtg==
X-Received: by 2002:a5d:6705:: with SMTP id o5mr9808907wru.426.1588864406980; 
 Thu, 07 May 2020 08:13:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id t16sm8235479wmi.27.2020.05.07.08.13.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 May 2020 08:13:26 -0700 (PDT)
Date: Thu, 7 May 2020 16:13:21 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
Message-ID: <20200507151321.GH237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-9-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
>  	stage2_pud_clear(kvm, pud);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>  	stage2_pmd_free(kvm, pmd_table);
>  	put_page(virt_to_page(pud));
>  }
> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
>  	pmd_clear(pmd);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>  	free_page((unsigned long)pte_table);
>  	put_page(virt_to_page(pmd));
>  }

Going by the names, is it possible to give a better level hint for these
cases?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
