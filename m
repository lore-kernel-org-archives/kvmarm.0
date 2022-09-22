Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41C4C54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 18:36:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27BEF4B1C6;
	Thu, 22 Sep 2022 14:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RzoBs0uv-JTB; Thu, 22 Sep 2022 14:36:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F364343482;
	Thu, 22 Sep 2022 14:36:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A867413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:36:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JYAOfk1SMdf9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 14:36:51 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53BFA40BA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:36:51 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id d82so10121071pfd.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 11:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=xeXyRnO8u8qVtwLZvI7KUvwb1dqHZEKqSauwoLHPeRc=;
 b=MsUFO6ksxwknDRS63WqbV1UjW5K0WfIUl0VExSg8G7NqaDX7mcUTMOcEiNxFOV+BhQ
 9a5D0Z6m6byKH5HgDjTwYnobNTPmvpHk9Uth/EYtfLi+OZFc9ywioBJpjiHi9L9mYmXZ
 eEPgLM+ccNS9qG2X2Up6IHrLG3vW5Pg5Z41D6QPOKV3WuGpbDFWOel4ih1Lx4m6P8aVW
 Su7zzz9KdReFVAb75/XJ6kniOw2XOaT9bqIOSRm7j6mxeji68AdP4qslI9vbpw6zmyrX
 rGeV8cOlXHyyITUwqyINLkBwMewVO9AEPMsfCU8i4zjDVYEfgOl99urBhq+iGMWgCnVy
 s7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=xeXyRnO8u8qVtwLZvI7KUvwb1dqHZEKqSauwoLHPeRc=;
 b=hNYwkwG5b+Azp8+ZwJJLarPXsboCgYwlGRwpRPSKzbgQs0T69YKTBrVs3bo7rkoHL3
 P/wfYXijx1SDuwR8nkJco0kDojFHykLpPV++vbPXn3Xo67mzDRJjnpm9XEiYXjgilxzV
 f5FGl5/eawZsY63eLuTEZ47NvZTyb7B7MJIlKY9IJSRCxe86vDACHwWit25VuSoiJ4US
 uHgW46mcfOuoQ6FtMLLaf4dhtG9nX+f9lUq+qNzVbyyMN9ge73KXLAZL8uNL/FUPpyam
 3eFz9QaxIkU5ebx7UM7uNw4Ey/SGdnDQd6wnnD3OeJhmMuVCRwKIre4N8klxEFUkn+Ij
 pFrA==
X-Gm-Message-State: ACrzQf2dxKTe9c373pCZWaR9bs1GHvjEqPxCId0XVxP/JfgnmDw7iiQf
 K/Yv6SBf07Kr2p4jWEHwL1luzQ==
X-Google-Smtp-Source: AMsMyM4f26ESxlQUpfb5qvMMZlT9zu+S1MjQerkiPWv/MbVFfr/KRg36FzW9sYRc0FqcUzIsoDWH4A==
X-Received: by 2002:a05:6a00:174f:b0:537:6845:8b1a with SMTP id
 j15-20020a056a00174f00b0053768458b1amr5104834pfc.68.1663871810305; 
 Thu, 22 Sep 2022 11:36:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 k81-20020a628454000000b0054cd16c9f6bsm4739560pfd.200.2022.09.22.11.36.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Sep 2022 11:36:49 -0700 (PDT)
Date: Thu, 22 Sep 2022 18:36:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v8 09/14] KVM: selftests: Use the right memslot for code, 
 page-tables, and data allocations
Message-ID: <YyyrPpDwwZSkzGu6@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220922031857.2588688-10-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 22, 2022, Ricardo Koller wrote:
> Now that kvm_vm allows specifying different memslots for code, page tables,
> and data, use the appropriate memslot when making allocations in
> common/libraty code. Change them accordingly:
> 
> - code (allocated by lib/elf) use the CODE memslot
> - stacks, exception tables, and other core data pages (like the TSS in x86)
>   use the DATA memslot
> - page tables and the PGD use the PT memslot
> - test data (anything allocated with vm_vaddr_alloc()) uses the TEST_DATA
>   memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
