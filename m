Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92102563
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 16:45:31 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id e18so21353961edj.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 09:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCJsHqR3fQYSgnggViyn3fMnrEwEtr4DogQg4RXYXfU=;
        b=OTRdidlgd4M+FwW6O5/QmVZjVoFUteHzrGjxAXNpavm6P0/bJ2oKKpVtri2Z7qkcWS
         5JWQYnY7afyOrgZhzZHFjmw9efVV2gjkQeFaMP+fmwcjwuS82qAivOdVz5DIm0te1MzR
         Pwchuxk3ooNK3QdvuAjNh9l1YqcgHyan06709W1zjjCD+KSz3zjOVbT3bqFpQ2yp4hIC
         qbJxL5Oy7NcTMET5jxqyahqZNxTVKcYbOiWxUa0zcvNgixzWyb14gNlz2O+9P7yC8xtY
         EREtg4jooDmz6U6w/mtou9+3RUms1DMcQaOFJyWn+75HCVGcEWNWxCPIirthBvftBJoq
         VGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCJsHqR3fQYSgnggViyn3fMnrEwEtr4DogQg4RXYXfU=;
        b=R6x7Tft47riyo+QyxaiIIdj2mIFxmC9+Kw+1WKNXMgTVPmt0nL+00cBSL00YzAQ2vo
         KzVNApPwn8GWRHMLodVxXUtxhJslynY7nbSg+LfgXhrJn6puKbCPaMJC9JzVY8oEoF06
         71N9yaypqUT2Pimgnu44ZIARzmWPM/4q1X7ZUwfsxQfLXtJY0w9OphMEEjEHvw0JQh32
         0ikcuFsOxJqlke/px6ZYSmxTgdlC5oZD/3cYXyg+asI4MQy7HON6usxAjJe8Y6LFTHeh
         s37x4v1lLSmfqPc14bcWomhfxobABIEnn6YYiM7dGyRx/IG2f6gBbwgg/25kqANQDdzT
         frgQ==
X-Gm-Message-State: ACrzQf1S15iN/OMD2S0y6HA5tpl3cr2Fe4ZyYQ9EQx2Q5Y2PsTIgyLcD
	eCdikT9Ntn9tW33o6St5z9Cc8XNI2bPuTQ==
X-Google-Smtp-Source: AMsMyM6I0P0S9DziDRNVM+YYRXKEEihJKzfSjWKlLw6I00yhLT/182go6gfMS7BANtRyQPharE/Otw==
X-Received: by 2002:a05:6402:909:b0:435:a8b:5232 with SMTP id g9-20020a056402090900b004350a8b5232mr3457453edz.240.1666111529948;
        Tue, 18 Oct 2022 09:45:29 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id hx15-20020a170906846f00b0074134543f82sm7856285ejc.90.2022.10.18.09.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:45:29 -0700 (PDT)
Date: Tue, 18 Oct 2022 16:45:26 +0000
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
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07YJvEsUnjSasA0@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +static int find_free_vm_table_entry(struct kvm *host_kvm)
> +{
> +	int i, ret = -ENOMEM;
> +
> +	for (i = 0; i < KVM_MAX_PVMS; ++i) {
> +		struct pkvm_hyp_vm *vm = vm_table[i];
> +
> +		if (!vm) {
> +			if (ret < 0)
> +				ret = i;
> +			continue;
> +		}
> +
> +		if (unlikely(vm->host_kvm == host_kvm)) {
> +			ret = -EEXIST;
> +			break;
> +		}

That would be funny if the host passed the same struct twice, but do we
care? If the host wants to shoot itself in the foot, it's not our
problem I guess :) ? Also, we don't do the same check for vCPUs so ...
