Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5C07F
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 22:08:52 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id b2so12043746plc.7
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 15:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/4DPPSX+8EYQafccV5qoWyCAmySO2GlahoEOcD6yiE=;
        b=Yr6JLfOIBxsKsz9I81OiNXnHbvZe5DM4pgR+uEoYH9sosgPO2rEO9K4G+qgZcbCE0U
         dTjnOvWDqDSlsJfMdwq3OtHjSYCYd3/LLgOEG5kyfW2xJhshGpV8I3QhStzNjmwrCJ0A
         gYEc6qcNjEDJoOlg83VOzJm1C9FvslOZE52zCPRKmR5jIRODorBIp1kj6JrSJJzQZqQE
         I+X0qBQoHjnWHd6E2mDIrvtlcei3hjswxq7xnKtwkiV7YL4gFTCpNIkofc842YMEeDRj
         eOpmxZRx843MuJ2S2rHWvSqj1+3EhvznOxSzyBMMZpc+HrJVthRanCFpAx6bGuHwJ/YG
         7DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/4DPPSX+8EYQafccV5qoWyCAmySO2GlahoEOcD6yiE=;
        b=dK2WjP1fwaFPlzwSCkwmNe/IDgrBpESaCnXK0f5bpyPzgUvpvj5B1qJ71hxyw/RsBX
         GfDqrmfng1M+LmP3Uv1CTUu7m7cQXXkp1aWCu6CQkrVGsbDiZBKgAa5ylT1IWb4Jewme
         /P4xwF4Kk6lDjvme1/OI2RDuFM/1ZBdZ+8UxDE4khv8DXgQxS2Ae4oAo4zZQKnd5nG39
         hM9+bwfRF3XjMerh+ayMIdc3492zq4aoBCmU+u5FuPr0iFCqwNb2F0Ubdd4z1zgtI1RB
         Lgd4avvJkWfBpJr10QZPmUx7s3zLZAfKqWJPJSx8IvMCeVun28CPdsaqyfS/kdpZFWRh
         7L+A==
X-Gm-Message-State: ACrzQf1H0JY/thdlio/vOvS4d/k1p8DUlSJPV0MPcfpiGKiG+RIBsOND
	p/tAyWG9ll6S75WwancodUPzkQ==
X-Google-Smtp-Source: AMsMyM7OKbGy+gHYEZBmAhjYnTpH7SayEGMvYLH1S8U7VKh6K5NkPUXY+1ryx2Vy+ZsIUIHEmiPNNw==
X-Received: by 2002:a17:903:2347:b0:181:33f0:f64e with SMTP id c7-20020a170903234700b0018133f0f64emr14442474plh.106.1666044532381;
        Mon, 17 Oct 2022 15:08:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y17-20020a17090a8b1100b0020936894e76sm6659955pjn.10.2022.10.17.15.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 15:08:51 -0700 (PDT)
Date: Mon, 17 Oct 2022 22:08:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
	pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
	oliver.upton@linux.dev, peterx@redhat.com, ricarkol@google.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y03ScGUUCA1KwlLF@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Message-ID: <20221017220848.mY7oqVLOVa1PnnylWz2J0BC3_QWFiKP5_MqVMuviMvs@z>

On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > +#define MEM_EXTRA_SIZE		0x10000
>
> Also, an expression like "(64 << 10)" is more readable than a "1"
> with a tail of zeroes (it's easy to add one zero too many or be one
> zero short).

+1 to not open coding raw numbers.

I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
16KB, 64K, 2MB, 1GB, etc...

Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
math off of those.
