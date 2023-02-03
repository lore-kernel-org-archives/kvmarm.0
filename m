Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE162CA4
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 18:41:32 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id l4-20020a17090a850400b0023013402671so9603188pjn.5
        for <kvmarm@lists.linux.dev>; Fri, 03 Feb 2023 10:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cn1ilt9CXu68kWVudz6MPv9G5X8jU8YjMqpSgc7Tn+g=;
        b=XVRfE7KZ96kUXnbwCAulTyZIfAPDcnownBSqk5Y3zjOlf0JvaGsecZQGPfFDEgYxzn
         /Vu/Ya3+pG8qgiG9wXNTWTNynt0NglLqATwLeLvan97Q6holYvnf3ZPq8UQiLpsaPv2V
         KeMLowFsRoKXEhCKwj09qOPIdbTjcL7+c+TMxbdSTKNR3RQFCNk6/g6nKXygjDkgFSjz
         PAN9X9glsEwV2LfuR5xGUIti8PaJDvsvznqtWyBIbODEaJkLgo6limUqFgvZ9Y+TVFJh
         gjg7SrN+FgksbwX2zYaP3j630WE0s5pStFCC1d8OsxgxVSofeRXg1Ir14LGkeUzhAWZH
         2X9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cn1ilt9CXu68kWVudz6MPv9G5X8jU8YjMqpSgc7Tn+g=;
        b=1t0JEMt5hkfEpC5Ixe+3dcM+jyGnuGS9RFWs68dAAaO3cKGHanexBrvibKCKfQQjDQ
         K6uUqaUpgnXFk7x8V4JT/SsHXmaWn/ofvKTV1xYAWP7udjlWYcfQBKUtGIxCkz+o5aaT
         9/tkGG9wk6EUOJfslxPsCCACx1XYO+4PPmsAKWk+UAoXC0LsejHFNUzmSrAVtJFDKwdD
         werwB+g/q35dJhxFBbe4tPT/MZNtdy+gMHbb9Zsd2K4UGVyhNTHyCEVk0OeoUPYcfZfk
         NUfR+FQBo85E+vKhljtYSHD7FEPU807FbXDwd52BbBRZs04m7BZJ8aYK7kZglkVqrtpR
         22jA==
X-Gm-Message-State: AO0yUKU/eKjqPApBp7gVoONsfl/mxmwU5AA5ub6yhKl/8gQfGgJyZM3S
	3BTW4HVdHyt9QW07gK/G/kn8ww==
X-Google-Smtp-Source: AK7set81ndZ6iqL6SCLrZ4yXsjNr0LajPm5EI4Bs27dAno1HwoKfEuLTFYxjXvbxcfsUY/E3yzW2Zw==
X-Received: by 2002:a17:903:210d:b0:198:af4f:de0a with SMTP id o13-20020a170903210d00b00198af4fde0amr10312ple.10.1675449691546;
        Fri, 03 Feb 2023 10:41:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e15-20020a63ae4f000000b004f06ccd76bcsm1793496pgp.70.2023.02.03.10.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 10:41:31 -0800 (PST)
Date: Fri, 3 Feb 2023 18:41:27 +0000
From: Sean Christopherson <seanjc@google.com>
To: shahuang@redhat.com
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <linux-arm-kernel@lists.infradead.org>,
	"open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>,
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.cs.columbia.edu>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Remove redundant setbuf()
Message-ID: <Y91VV+WWrakREsN6@google.com>
References: <20230203061038.277655-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203061038.277655-1-shahuang@redhat.com>

On Fri, Feb 03, 2023, shahuang@redhat.com wrote:
> From: Shaoqin Huang <shahuang@redhat.com>
> 
> Since setbuf(stdout, NULL) has been called in kvm_util.c with
> __attribute((constructor)). Selftests no need to setup it in their own
> code.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

Oliver/Marc, want to grab this one?  I doubt there will be conflicts, but IIRC
there are a handful of in-flight changes for aarch64/page_fault_test.c.
