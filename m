Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DFED50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:02:22 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id x66so209744pfx.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHOMyfsfvQkL/nShVDUzK82mKXXqJYsG0axSizIXaLY=;
        b=NnMo7/46lbMBrXBXQZRYVq3GggYMT+7jEJcq9CL/cSVNfI9/zGr929gpN24qaTzNDj
         EuAX3kX5hoFkykznYnPSEMhpqrvV96Ls6XOPXnZJFhl++LMNCZ1xBLhLYGuEyeIeBOlg
         1Pda6St2Grg/DjBtBU5P+snxis04vfL2wZmjtsQkvZDNryITBkJPcp25ppL/joru6uaX
         pdFAr7CPrxA89GBOBBQLxyhlYq8vGrdtF3rzEmU5z3DvHeLGy15BW/hWdiMul0LnS4v8
         aUBoc+y5QRGugr1owVbIQyI2ZzhFRbthIb2QpbXN2iQwGAYLSCnMYOTrkzCCC2hVImkh
         7vwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHOMyfsfvQkL/nShVDUzK82mKXXqJYsG0axSizIXaLY=;
        b=cGfxz95XdmathOvJRKmyN2emsgb7NPSo6W3zMnG2NW1cvB1yaXj3kDXuNt1vLx8+yp
         nruQSPvUIv6g2/o6oTDBGiHPu1KFvra1TVNA38HHpQXqFYZaeRQlxq2zdSKuSAgSkK2h
         8CTqgI4FOsEIX4ikX3xQyg/ldb5dVHMwXqFtA2swEs6d3FkhrMeJtbWsXI59PRikfiAW
         Do9AZcFpA4iBPyvcEGQ2Zg1oBxN+0/9It9k/UZ/85NaRt7m6GArTj9zsemcw8ow3hHtv
         hT6duEXc4LYWNDDldhtHqE9psWEeWqXdK/zHeP1tyhyHdaWWAFGuHDD5kT4fKELhOYQa
         /acA==
X-Gm-Message-State: ANoB5plKcQi24eebWTj0bUD+OQgYxcPBVfQ0VNPy508pYTgQ5nEDg/7n
	QV97DWVZ/y8myulo3cwxmG8Nig==
X-Google-Smtp-Source: AA0mqf5Nj1181KAxR2A/WI368LXBMRYoBlCi8ORJRhPIy6nAs8C080UTF7/1gaOFg5Avl9sdvRAfNA==
X-Received: by 2002:a63:2361:0:b0:45f:f8df:108e with SMTP id u33-20020a632361000000b0045ff8df108emr37236360pgm.127.1669849341423;
        Wed, 30 Nov 2022 15:02:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a6-20020a624d06000000b005633a06ad67sm509519pfb.64.2022.11.30.15.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:02:20 -0800 (PST)
Date: Wed, 30 Nov 2022 23:02:16 +0000
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
Message-ID: <Y4fg+MO2DusqMSZO@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-33-seanjc@google.com>
 <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
 <Y20r2NR9MaBbOGLn@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y20r2NR9MaBbOGLn@google.com>
Message-ID: <20221130230216.nBqvIxAnMNmA9OHacvsR_JumR8y82gHpz9loGqzVNhw@z>

On Thu, Nov 10, 2022, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Robert Hoo wrote:
> > After this patch set, still find some printk()s left in arch/x86/kvm/*,
> > consider clean all of them up?
> 
> Hmm, yeah, I suppose at this point it makes sense to tack on a patch to clean
> them up.

Actually, I'm going to pass on this for now.  The series is already too big.  I'll
add this to my todo list for the future.
