Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E72F39
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 15:19:27 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id v17so1918559plo.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 07:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=54/qpLgKvMYRxZZN8WRThBEEYZ9T1CEvYfUVPrQm8ww=;
        b=iMSmmJd/PxvPh5Sz4Mhlv1D7h60/wqpXa0IlfaaP18ffK5JF15qrDhUVUrU0mPM8j5
         +yh01SuAl11IdhGv9HRnwbEbasiIbUwNJEroOSBoHC0PSRXsMxFlfF8m0vO27W0kb1Pm
         KpWAdkZ8OeO3IpRpd7GTMe3WaNU7LXQu8BNCDaNhWSHry1EDfm4x45qAKDcZTJ20US1O
         HaNzNoB5jQwXfuuGssFqSarSg2xv7H8v2ew9s7NTFe7wL3tI+gGTER+rUYg94g+fS9ez
         W2tfqJxdHRLZU8/vA1csfuG18K2GHHfSzgBem4hC01N5DJZYllLM7dekVdhJHFeniQQy
         KmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54/qpLgKvMYRxZZN8WRThBEEYZ9T1CEvYfUVPrQm8ww=;
        b=hRZzRe8s/Aieoe1qC9XEyhsK1WE56eWhqaUyg5eKL+MUU6v4nsOZqtYxYRxj0yfJRT
         RjnPNwVHkP5fMZDELt1K9McqiOe/epOLQ+86g58cow7BUXUSi4vJYf+gg0p48UO33KI4
         0/AqW1p5Y6PERRDVTmcST3AKdF+pmdnW7/9G1ZegQiV1Tkx/HZrB6qWRgHQXOOwj6WUB
         7/2oMRYO0yEXDm7Qa9t3V66Sm52S57IY0gckIoN7FXOQesDVqtw1OIguSHCTRAHUJSlX
         Q5s3s/+emoLd/X/DGD9MO+q3XzKMfa9PdIyPJIzbQ+WZTxvyhhX0mhwiZf67c5JzgPYU
         mp4w==
X-Gm-Message-State: ANoB5pncXqWjIzg8/QAEl00/Q0CGWeXcGULfqw3VfpXmMbwRR0JyFNVL
	co8bA4JOfowvPCiQ0/Lu3rvqJg==
X-Google-Smtp-Source: AA0mqf4wrBLIgo7T2s4WuThT5jIfJYx8a5rV1w04DyLTsZXzfk7fRoTfBUBdt+cr0oVtZWuIShH4JQ==
X-Received: by 2002:a17:902:cf05:b0:186:de22:7968 with SMTP id i5-20020a170902cf0500b00186de227968mr3286934plg.3.1668698366550;
        Thu, 17 Nov 2022 07:19:26 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b4-20020a62cf04000000b005668b26ade0sm1242098pfg.136.2022.11.17.07.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:19:25 -0800 (PST)
Date: Thu, 17 Nov 2022 15:19:21 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3ZQ+fCobB4DOc+S@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
 <Y3WF8YlvFm8NGYHd@google.com>
 <Y3WMeovid9z1qOjD@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3WMeovid9z1qOjD@google.com>
Message-ID: <20221117151921.abpm0pvxqwDkjp7dXJwaXoCBztBaQMagvWQwFiCXuIk@z>

On Thu, Nov 17, 2022, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Oliver Upton wrote:
> > On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> > > Automatically disable single-step when the guest reaches the end of the
> > > verified section instead of using an explicit ucall() to ask userspace to
> > > disable single-step.  An upcoming change to implement a pool-based scheme
> > > for ucall() will add an atomic operation (bit test and set) in the guest
> > > ucall code, and if the compiler generate "old school" atomics, e.g.
> > 
> > Off topic, but I didn't ask when we were discussing this issue. What is
> > the atomic used for in the pool-based ucall implementation?
> 
> To avoid having to plumb an "id" into the guest, vCPUs grab a ucall entry from
> the pool on a first-come first-serve basis, and then release the entry when the
> ucall is complete.  The current implementation is a bitmap, e.g. every possible
> entry has a bit in the map, and vCPUs do an atomic bit-test-and-set to claim an
> entry.
> 
> Ugh.  And there's a bug.  Of course I notice it after sending the pull request.
> Depsite being defined in atomic.h, and despite clear_bit() being atomic in the
> kernel, tools' clear_bit() isn't actually atomic.  Grr.
> 
> Doesn't cause problems because there are so few multi-vCPU selftests, but that
> needs to be fixed.  Best thing would be to fix clear_bit() itself.

Ha!  And I bet when clear_bit() is fixed, this test will start failing again
because the ucall() to activate single-step needs to release the entry _after_
exiting to the host, i.e. single-step will be enabled across the atomic region
again.
