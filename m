Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0118B2578
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 19:17:08 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6af8b25fc72so92213a34.3
        for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1685560627; x=1688152627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MHtweHA3SWHMpKKRoTnSYY+2sgOnMlETASaKZp5cnWg=;
        b=G8LdxrQVJXzPvDv6pj7E1fjzv3QptzwoXHIyMdWEmnvJfe91bWWQtAEUbaA6Nzl7Ky
         WCqn5A+Ib0XWSTJicI7+WetfhK7KQp318g0KeWJT1/vt4cdoJbEX7/oEO9dSKb/it9kA
         FsRFBszIqWGuho6X7dJOAYHqRjKwcQ/Jyz/eVKr5ZRT5HKgJuIzgfC3aRXtVSAyPaXoc
         ZnOEI6C1jQy2wrHvtZe0yTA1D2Gu5BufPvPbIqjVHpYfOSNMzoMO61TFbfhGoJBFYoYi
         mnzg1QOCQwYafPevYqJT5QgdPe4Jxi6B0eCez6eIsp/lkI9+cx82bblFziCVR9vO1iYZ
         mFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685560627; x=1688152627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHtweHA3SWHMpKKRoTnSYY+2sgOnMlETASaKZp5cnWg=;
        b=HR6n/yigyd7mp2H0Qz/GOis8aAKhw7k1n1Td3tVVKGpBTViBEZAetQ3tRowAfEDfNV
         0u2u1JFL/wYTzx0afWjY0+emRsupdBTCtgL+4D+Ayl+z5kufc5h3NUHcoc5DoCxfJ6Q6
         26QGx8NH1lD42R/Q348Su6QH3OO1whl8P8Xy9jUWmwtV6zKfbXt+alxuxO3jEnwDzeIU
         ZhhklHsOOnu1rLxoTGbveoUTEqSVjSGDE0yW3wmyja+huxn/Swf2WReNn0gyCm5TFgvf
         z7I2pzySmlWDMdecWZcd/1qfum6n6i4kjkGrlQmDM9P7siI8px6gkJqzjwFphxZjZzLV
         TOeA==
X-Gm-Message-State: AC+VfDxxZGtL3yGOSqJzQX/cB2eODu8gYldLrYfj2wNMCYwtyi9G256N
	yDFHSQD6aOVxkyA/rZc5eDOUBw==
X-Google-Smtp-Source: ACHHUZ5EAb6uxqk7kkbizac+JrcIuoYNmIlHHRhpUDjRmBZ8boj1JThitoXP6J0DZ/TEoplrWHjlbg==
X-Received: by 2002:a05:6358:7e9b:b0:123:3203:928a with SMTP id o27-20020a0563587e9b00b001233203928amr1487114rwn.27.1685560627568;
        Wed, 31 May 2023 12:17:07 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a300300b00250d670306esm1594668pjb.35.2023.05.31.12.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 12:17:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1q4RJh-0017d4-7W;
	Wed, 31 May 2023 16:17:05 -0300
Date: Wed, 31 May 2023 16:17:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anup Patel <anup@brainfault.org>, Ben Gardon <bgardon@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michael Larabel <michael@michaellarabel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-mm@google.com
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add
 mmu_notifier_ops->test_clear_young()
Message-ID: <ZHedMX470b7EMwbe@ziepe.ca>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-2-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526234435.662652-2-yuzhao@google.com>

On Fri, May 26, 2023 at 05:44:26PM -0600, Yu Zhao wrote:
> @@ -122,6 +124,10 @@ struct mmu_notifier_ops {
>  			  struct mm_struct *mm,
>  			  unsigned long address);
>  
> +	int (*test_clear_young)(struct mmu_notifier *mn, struct mm_struct *mm,
> +				unsigned long start, unsigned long end,
> +				bool clear, unsigned long *bitmap);
> +

Why leave clear_young behind? Just make a NULL bitmap mean
clear_young?

Jason
