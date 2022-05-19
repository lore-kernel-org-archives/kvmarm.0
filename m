Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98621C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 04:06:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 147AC4B357;
	Thu, 19 May 2022 00:06:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uwDGVKQzXP3V; Thu, 19 May 2022 00:06:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A0D4B2A5;
	Thu, 19 May 2022 00:06:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B026B4B211
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:06:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BdpBE5oS1SlR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 00:06:25 -0400 (EDT)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BE834B20A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:06:25 -0400 (EDT)
Received: by mail-il1-f175.google.com with SMTP id i15so2876915ilk.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 21:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=HhVEShRLiA+12WawJvWgAJ+fjJb0wYw/1qh/Y9aGX+I=;
 b=ogz7DNKJecGaILna/pIfBmTkCUQ0IDjLM2lIY6bVnXStms7HvXaWhPNFVZQpJOuME7
 hiG4Cb1R6gAcg/a3LGJ965Y8bLxqp0aoRviXvUlJxaCsebI9UP2TCTu8kHf4bleXAp81
 e99Kto6D6axTTBBJyJaqH2EjkDI1+V+V88XAoqwFlcD64vlvpKvYTfUYO8GRzy009Yq3
 21ndy5uCKoq8ktMtl8mH5vq/rHB8TKMKS85J48+H6vBh2lPwYKzNlb9Q5tP6i03/1c7K
 waeMCDk0aGZav8FsSXwMaSQTo/3ruW7wsqQNPXt3esPBlFxxP5RdPjU4i3LLlag85HnM
 JN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HhVEShRLiA+12WawJvWgAJ+fjJb0wYw/1qh/Y9aGX+I=;
 b=QXKPT13fDxZieLnJOwCv4um4c3OchHtiInecBPtzblJWVXEnFjFVo3MwUBtEmmlter
 sIXhF7WJW8z195w99Vky3IGEof6DPPTBcJyXXtfQ+wxYIc0+HjEfqVMrnZuRepm9Thiy
 dMDzyu0Iq52YXzOvLXgxhd1OLUTFaY8Slj2CPCu3PyVdSr8PBjU6ZBgsx7ufGw8GUwyq
 EBDNIF8T32ZHScIgtFW3kWf7fgxh1EyiiLHiBDl7G9skJRM1QQuK/mUvqnB3uHUjU7vP
 kx3pynGWzmKuu1P2JEe2S9Fb/rZiPqfmR/JvRj+bnwVNeIMF4ykZxA1KuT7B4i3x5k0h
 Ri8A==
X-Gm-Message-State: AOAM532n2CiPfH/kxe9Y1ZCT8jwA1RFR28mJ3gNv37rdgbqDp5np/ksI
 qlPuBXInxk5gA9gtBy5jEKhVkw==
X-Google-Smtp-Source: ABdhPJyDNKNdKdzRYimEVo3cF1jsSGbss7PpQ0XEbUzPSBGtA2IzoggWnfSxssA4jHP2jFRJSxKILQ==
X-Received: by 2002:a92:c985:0:b0:2d1:2e3b:bfc7 with SMTP id
 y5-20020a92c985000000b002d12e3bbfc7mr1569358iln.186.1652933184615; 
 Wed, 18 May 2022 21:06:24 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f13-20020a02a80d000000b0032e868301casm192326jaj.45.2022.05.18.21.06.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 21:06:23 -0700 (PDT)
Date: Thu, 19 May 2022 04:06:19 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 05/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
Message-ID: <YoXCOxjjfu4WUuEC@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-6-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-6-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 07, 2022 at 05:41:12PM -0700, Ricardo Koller wrote:
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
