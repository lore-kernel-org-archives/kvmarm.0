Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456C1C43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 13:12:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BBA4B376;
	Thu, 23 Jun 2022 09:12:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HoCB+-EEADwd; Thu, 23 Jun 2022 09:12:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B22174B37C;
	Thu, 23 Jun 2022 09:12:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 109684B376
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 09:12:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VobDYOtfOLIO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 09:11:58 -0400 (EDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CE154B329
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 09:11:58 -0400 (EDT)
Received: by mail-ej1-f42.google.com with SMTP id ay16so21630803ejb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 06:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=44rAwtd104zTF6dbWV55JEwGL2BlYGz1AUagrivcDtc=;
 b=piKrs1fQPx5PzIuxBtvL8WJ+ocepEXzMVOvQ+r6cSg5qEzEerxBPDNCRzEFSpmHsSd
 H/7xc3RxTA72PAXq+GCknvZV+fMuWqC7x/2zMuJYHWRFzUrNfUfJQj6QRyAGBRgSJPMU
 y1RTLYyMHy1BsEU/SqfTGz0vUcT4mnUhvBOcnhUN7+Rp9ZtTmRb2foY70s71EDNnizvO
 jr97BogCpA6Ba5P2VFa3WcJjHFkK1y4UrlbIpmKlKXdfZqpWFlK0cmjfVfhL2tOkDPW3
 Zi8nXg2aPPMmJ8rqlh5eUhhVVv2WciZFnH73jNHTHyPpURR00aUSAQGk4T2XEA2hR/a9
 I9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=44rAwtd104zTF6dbWV55JEwGL2BlYGz1AUagrivcDtc=;
 b=aM2EtFnIM3BYPTXHiRAIw0wyN9jjtZvjFklasUNzwaSvrsJ5U3Xxe7hL3LM/8Boiz+
 W3I+DED+kjEixSCbFot63t7Jr8HDleEXDBsoudvxiphrB1EkfKUO+/nkLToUAcu5YAEz
 g5wHf6uR0zWbQWuHRUnXrNCFyHlTL/r1eGC5fshLA1CShz15SU7N3FnlA5iQ42QrGasV
 ivD4YsVHvZ/OkWDNVbkSoMOwN9yo8dmFl54q6tZmnBBBwIAXTbpwhjAop/oJyhXdZ4pF
 52C1yceQGIONqBKm/dHHQFSwvXi3Mx7aXoK+kOZrhNFM6M0n9Ddh/hFJtzXB7/utwOMq
 ZbTA==
X-Gm-Message-State: AJIora+qsWrevnCdZypk4co0TdsuuQP4BdOyz/MlhD1H2rGYxaT7mrtx
 4i5N0I09nv1wWWOkez359ZQ2/g==
X-Google-Smtp-Source: AGRyM1s8IYJ+YI+ZlWvmtnpwUn/+h1WW0BjzOTyTurp9rd8PjvArrkWRTFjF180z3zStfWcrby+HCw==
X-Received: by 2002:a17:906:5053:b0:70d:a0cc:b3fd with SMTP id
 e19-20020a170906505300b0070da0ccb3fdmr8007855ejk.162.1655989917478; 
 Thu, 23 Jun 2022 06:11:57 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com.
 [34.90.227.64]) by smtp.gmail.com with ESMTPSA id
 bx25-20020a170906a1d900b006fe8d8c54a7sm10873956ejb.87.2022.06.23.06.11.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 06:11:57 -0700 (PDT)
Date: Thu, 23 Jun 2022 13:11:54 +0000
From: Quentin Perret <qperret@google.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: add a hypercall for disowning pages
Message-ID: <YrRmmrY24Pv6hyAO@google.com>
References: <20220623021926.3443240-1-pcc@google.com>
 <20220623021926.3443240-2-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220623021926.3443240-2-pcc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

Hi Peter,

On Wednesday 22 Jun 2022 at 19:19:24 (-0700), Peter Collingbourne wrote:
> @@ -677,9 +678,9 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>  	/*
>  	 * The refcount tracks valid entries as well as invalid entries if they
>  	 * encode ownership of a page to another entity than the page-table
> -	 * owner, whose id is 0.
> +	 * owner, whose id is 0, or NOBODY, which does not correspond to a page-table.
>  	 */
> -	return !!pte;
> +	return !!pte && pte != kvm_init_invalid_leaf_owner(PKVM_ID_NOBODY);
>  }

I'm not sure to understand this part? By not refcounting the PTEs that
are annotated with PKVM_ID_NOBODY, the page-table page that contains
them may be freed at some point. And when that happens, I don't see how
the hypervisor will remember to block host accesses to the disowned
pages.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
