Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8172F55
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 15:26:34 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id m7so5285208wru.8
        for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 07:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tjEUzLFjJmxfniuCdsNKzTQp/eXm9sRTYtnzkPTRGE=;
        b=KUexmgRu5iOOfgI9R349Jd8L2TyoFbY1EsZAokQ3a/7AM3waZn4yATTO1YrXdP8Kkx
         z/0f4L+QJcoDx5Jc2YiSJDMPuTJ8B0SXLJYGhAos7+7yimV3ZtsDMFRmIYhi7FSEGK0Y
         0B+2LfXh35sh1pdV9VUXz7s1hPuuZWjSLwlxaL61ndTEOwewE8naS+Pd3OlyBQ1zracL
         G67VJ+/oXtHG3eqDbpQiGSLl0vkaz+vnpH11xG7Wniomm6Pe5ayefFZsoihv6HZzdawf
         LIxM+KFl8helJIKHG11992tvJf6aFjAuN8VirRkVvAePOWtSP4Qj3mwuE446HVJWsbHR
         GCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tjEUzLFjJmxfniuCdsNKzTQp/eXm9sRTYtnzkPTRGE=;
        b=Wc4UcebRBH/40Rf5awq2n9JFtrrSQJTwSlGPXflN7wgyGz1Tv7M3n+ExrNN5wGD33o
         Q6D2fIQPRfsV46yudQaXQ6MW5uAsEuz/c2Noz83/r09yT9cufksuUgQnqaOJdLrVu0Ws
         OZqsviBQ3DEfx5ejFhmFGU2ojLZNGOURoRFP9pyITM6/SwPReVjWcF7NtJNKDylW6SsN
         OhlfmtAvCV5+xp5OQCWF6jJFPqjRxQFuqax8CbmYc3rrFEkf613hs0knhU/FY6WAyuJY
         B2uxBxOAsowa/tvAgk2iNvdGoSmecN+ewrYVH8+9WUtBzzjkZWdjIBu4YzNp+kcrAPAb
         Xfvw==
X-Gm-Message-State: AFqh2kpHqlwT4MtVSDBWDn4/s3wfgx85udJomUyDjMQfjKb70JUZn5/c
	yKMSrU+IdQzfEtCEQFC2WESUzg==
X-Google-Smtp-Source: AMrXdXva7H5XWHDFiLRxpONdNSBqnohgqBGHD8HwUdzNKwIZrLMJ1OzcPdG5hlDJpM6rYIT+Ntu+kQ==
X-Received: by 2002:a5d:5083:0:b0:2be:546c:4663 with SMTP id a3-20020a5d5083000000b002be546c4663mr23900328wrt.45.1674833192983;
        Fri, 27 Jan 2023 07:26:32 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id e7-20020adfe387000000b002be15ee1377sm4265350wrm.22.2023.01.27.07.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:26:32 -0800 (PST)
Date: Fri, 27 Jan 2023 15:26:32 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <Y9PtKJ3Wicc19JF1@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127112248.136810-1-suzuki.poulose@arm.com>

On Fri, Jan 27, 2023 at 11:22:48AM +0000, Suzuki K Poulose wrote:
> We are happy to announce the early RFC version of the Arm
> Confidential Compute Architecture (CCA) support for the Linux
> stack. The intention is to seek early feedback in the following areas:
>  * KVM integration of the Arm CCA
>  * KVM UABI for managing the Realms, seeking to generalise the operations
>    wherever possible with other Confidential Compute solutions.

A prototype for launching Realm VMs with QEMU is available at:
https://lore.kernel.org/qemu-devel/20230127150727.612594-1-jean-philippe@linaro.org/

Thanks,
Jean

