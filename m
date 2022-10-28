Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA7F1FAE
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 09:29:42 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id q9so11702108ejd.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 02:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bKzHROW3HlqVHFCQVYEIAGQO/GEF/7B37Q2yOLqpTPE=;
        b=acC1NH65fUHn+22X/MVKkVYc6pCCpJTS8anQGCsKRR7fejXeE/X/BY4MQTQbrUdYrO
         /zUDL5rfOXVPoIOi8aQmru/rBDm35rwQwnz/LEPthxbjGv12PZRu6dTLUQWjHCKAKKWj
         xlHubTSrs2IyVpI4UAFd2z726R+FG7O9NVFYXgEOqGvPgy9i+TU18+pgkEviSlWRiRUU
         IaUWJ+wIL0pcMH0UvivkifftNqQ/+DwbVtbi71Sb28s8K08Tn0hb9w8hXyUDRZWWt/Ez
         /icWm4QkaL/d2N01KarCI6JZZvh0yQ/vg3bPraCUQl6fx3wropNkioqoRMYbFm0eKMGJ
         v0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKzHROW3HlqVHFCQVYEIAGQO/GEF/7B37Q2yOLqpTPE=;
        b=ZiV4qIu6rKFoHg5yxvqtB82qrq7SWJ4dOn5pfI8BIehJssp0sTdhmT9b4+Q8KoUww9
         Oo+sMfDB4jIQecz4UVVxqfDQNrUzR6lwftuC45jqTlGi71LDjoMPNAvqeOIV0egaUotA
         meLVppioESw/i7/XSAA0ohijF0ZOl8245AOldQblGMciQNNJzyphoPV4eSPIgsaXRKhA
         R0R3hoGUld5bs+yjlmgoGRAitD0OITBA8AsDX3ZKLQaYinWq3BpOXz5AKNBQMxDqT40v
         9ta9Xxk1HJ2xrsN5/CLhYg/TXDTDuzLww0SRASNp/3l0QjY6+5UjiUnbMQqc/15q9kYo
         HG6w==
X-Gm-Message-State: ACrzQf1C8VBoV1B/5NLJ4UV2GDfxNvoc+nb2iLpY3zF6Xpeir0EG+RPZ
	V1TDBlDmhqDSYptWpE/6amDa4A==
X-Google-Smtp-Source: AMsMyM4PKCzkFjNUPVQTRmDdJVp41feWg/IGBeQ3XOnOrubUEl8MuW8Vq2rx6HtRpjEyThZ6kj50Ng==
X-Received: by 2002:a17:907:2c75:b0:78d:c201:e9aa with SMTP id ib21-20020a1709072c7500b0078dc201e9aamr46266130ejc.235.1666949380721;
        Fri, 28 Oct 2022 02:29:40 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id r18-20020a17090609d200b0078d38cda2b1sm1819419eje.202.2022.10.28.02.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:29:40 -0700 (PDT)
Date: Fri, 28 Oct 2022 09:29:37 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 02/25] KVM: arm64: Allow attaching of non-coalescable
 pages to a hyp pool
Message-ID: <Y1uhAbK5EiQz58iJ@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-3-will@kernel.org>
 <Y1sfpM3IjNvr8ckf@google.com>
 <Y1uOOGUMDlJ2tu2M@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1uOOGUMDlJ2tu2M@google.com>

On Friday 28 Oct 2022 at 08:09:28 (+0000), Oliver Upton wrote:
> On Fri, Oct 28, 2022 at 12:17:40AM +0000, Oliver Upton wrote:
> > Assuming this is kept as-is...
> > 
> > This check reads really odd to me, but I understand how it applies to
> > the use case here. Perhaps create a helper (to be shared with
> > __find_buddy_nocheck()) and add a nice comment atop it describing the
> > significance of pages that exist outside the boundaries of the buddy
> > allocator.
> 
> Sorry, I'm a moron. The check in __find_buddy_nocheck() is of course
> necessary and irrelevant to the comment I've made above. But maybe I've
> proved my point by tripping over it? :-)

A comment won't hurt for sure, I'll add that for the next version.

Cheers!
Quentin
