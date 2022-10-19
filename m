Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6580A7E
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 16:00:11 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id a13so25998125edj.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 09:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O1cLnZm/LoMDz6+B+n/voHfjErB3lHfA2RpQhUASGvA=;
        b=QEfVmhM5sGU3Xc0Ip8XZ+3M85MM3WzsDLdEFW3/OAoq7D2HKb5EimjYNE7sB4wabyQ
         ZlHQaVlLKXDEtCh+ZZkYC5z9NFwm+WSCKWH5t2oFd8Kl5q8JrIzPaKiQhzbAiI/uq0Y0
         sJJU+pEMOHvIpNtacM8sw/bQrS+ML3efhbqVqQlZH5D9NN8ky4KyzOkuCuAgJPVM1Nvz
         TozCIkrRoDHYWCaMPkyWN9GQRlw7F0C1XlpVvJ63Xc642eXLgBdDwC3OUZdHDhc6L+9U
         ODt5w2q7btTathGgOFXcYTeddKewwVS0Xs2ttNN0sLafHgUsZOC/n6tvTuusev3NFqDk
         nD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1cLnZm/LoMDz6+B+n/voHfjErB3lHfA2RpQhUASGvA=;
        b=DqqV2QO0V/2gOR2dN4G6mTyCtoWpG8LxYJQVeEFqXx5wezudgCMXQ3njrLNwuZ15oB
         99/6JCv8aukADMl4+Eu2D/PKbn4iiUedw8RUTM9LqQMCM9TF/4ZAu/KQYZIqbOFIx9/H
         F9UUUp5MRzoxzhRMUTbx9d3x/ivQISeVXIOZCBze0oaQCtVJocX+JEWFRnX5Y1WbDol6
         +CvNDTuNcV6L7PomvLEngf4zewGs/uKxgkPmXxtjUMh+5F8lIx1lSx1P6XkGEprmMvhZ
         KDDIgD52o+NtSSs2jKucNkgMbXZQLZlU/r84mE1lmY7KlWcrwc05DBdF4SO4jZTMahxn
         9/vA==
X-Gm-Message-State: ACrzQf35I33VBFK//E6UmK1z7xKYedtFe7AstIiHRUEp3T4G5ZFmqEsA
	7A68b3CFZeEl185qU80/6lq/5A==
X-Google-Smtp-Source: AMsMyM5QMuc5Rbw4TEB4HtWjB3v+wmX3RoEZYauNqEalxnRU7JT9FpVZpYv0p3M9Zr/IdzmzP0TTcQ==
X-Received: by 2002:a05:6402:26d5:b0:45d:8d93:d5be with SMTP id x21-20020a05640226d500b0045d8d93d5bemr8108248edd.13.1666195209385;
        Wed, 19 Oct 2022 09:00:09 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 16-20020a170906309000b0078d22b0bcf2sm9204303ejv.168.2022.10.19.09.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:00:08 -0700 (PDT)
Date: Wed, 19 Oct 2022 16:00:06 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 13/25] KVM: arm64: Instantiate pKVM hypervisor VM and
 vCPU structures from EL1
Message-ID: <Y1AfBrXcYlWBxig8@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-14-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-14-will@kernel.org>

On Monday 17 Oct 2022 at 12:51:57 (+0100), Will Deacon wrote:
> +struct kvm_protected_vm {
> +	pkvm_handle_t handle;
> +	struct mutex vm_lock;

Why is this lock needed btw? Isn't kvm->lock good enough?

> +
> +	struct {
> +		void *pgd;
> +		void *vm;
> +		void *vcpus[KVM_MAX_VCPUS];
> +	} hyp_donations;
> +};
