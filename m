Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB7DC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 21:28:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4885840762;
	Fri, 14 Oct 2022 17:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6VqygR2-srvI; Fri, 14 Oct 2022 17:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BE44B0D0;
	Fri, 14 Oct 2022 17:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FC8D40762
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:28:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V0pB3DKmpSPD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 17:28:11 -0400 (EDT)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 362EB40159
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:28:11 -0400 (EDT)
Received: by mail-pg1-f170.google.com with SMTP id u71so5409977pgd.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=TUL+SkC7/koWX+CyJ2/PD9/CBLbq2G9cpQ2gXTLP9mQ=;
 b=FJYhKHLLUm8mE2yX5H3zXOKYKhzcfIgAAI3C4FwOqjzD20sYlqciVAS8RJXmxiA9qW
 kJp1PhxazDMYSVxpUukm6au9DxjlqdYP6whWFEfbgIf77SwMmddhg/CqZuGs98m0hMCG
 52W2g/gteeV0i+2OswtkKH13tGy0Mba6L0JUuwwIAg9mFQVs1iMatpv15wJ43T16ycoV
 Lx2qBbAEDz7K+c8Qqf0Ika5zgaROXj26MSIwKp4jihHI2OXLZT9aO6mnet0aiUfWCzSf
 oejKV/39Uc76CV9VlOVngnUQ9XTvIZD8itnKt5lXysuPjQs0RWTBFj8uxUzfBvAecfdO
 V6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=TUL+SkC7/koWX+CyJ2/PD9/CBLbq2G9cpQ2gXTLP9mQ=;
 b=fHU5QU8y5FMl5JLvjKvDs1nr67CQgkpjFq7m3TI7ul3ezIAOdhkkn0kFm3VhVdL7Qu
 e3E5s2cC6UeaO4LGcnDha6y/2zTklwT5WrZ+mDeIEI4uS1En9qkkV5VknvKrXflSi84F
 ZVA6lPcYAaXw6tKfW+CQN3kOEhmsYS0qo4hi8iNZTM4WsBsAXyOioGJtHubnVpi9MUNe
 1xjwAEgRD7zaQ9Mln0jkYlLkgLGIarU5EohL13USJa6wl9HVOhbxL4YZHngkM92L3zVK
 z3EZ/97pkgQJNjFfHr4xqlGS8S87MdX48J01jmZQ44kPBV6Sxo6f3656K6h8FVFqC/c1
 EUDw==
X-Gm-Message-State: ACrzQf1kI2U3HL2ceaNjVYr40Tx6i4+rwqlxJHXeKJhr+Tx/zaxl7ZHG
 +CCmeq2MEl69y9adioLNnukgdg==
X-Google-Smtp-Source: AMsMyM7DX2VY33DbNCRga+aaC9tQU3wY2Pnt5YZgE/m67b//0sp7Yz2kcSc6xw7BXLbNRSRIGls7RQ==
X-Received: by 2002:a63:8b44:0:b0:45f:952f:c426 with SMTP id
 j65-20020a638b44000000b0045f952fc426mr6083058pge.623.1665782890167; 
 Fri, 14 Oct 2022 14:28:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 c16-20020a17090a109000b0020d39ffe987sm1893977pja.50.2022.10.14.14.28.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Oct 2022 14:28:09 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:28:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v9 12/14] KVM: selftests: aarch64: Add dirty logging
 tests into page_fault_test
Message-ID: <Y0nUZuiRJh/WUnVd@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-13-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-13-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> @@ -395,6 +415,21 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
>  	return true;
>  }
>  
> +static bool check_write_in_dirty_log(struct kvm_vm *vm,
> +		struct userspace_mem_region *region, uint64_t host_pg_nr)

static bool check_write_in_dirty_log(struct kvm_vm *vm,
				     struct userspace_mem_region *region,
				     uint64_t host_pg_nr)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
