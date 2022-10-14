Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF924433
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 21:15:06 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id s196so4067446pgs.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 14:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PZCd+YWp6Rkdf8GaAemTwPAfWHSubBGbIoqG74NI1ms=;
        b=cRoXvbDvQMwnmouYRU9bA6BnbMqIjlR+t9dwtgHTh24hpPv7uk3XmVXIJbgw6P8Eg9
         uU3QY2KRaVJK0F92yWi4lVW7keg0Y9Lful81loNULOo4P9SHVXeJSgQyrCaLfy3IHwIO
         Obc5PDktwXnmgO12NR7VgdJPy/2idgNnHwyMniFZgxK7Es52QbzYDil5VIddOwZ9ycLV
         /tsBIK0Z4qWqa44E/uQID8GzRzZNBvLyhcV8n6p+8JmNYRddayZJ+2GJDUnWEp21MPsQ
         FphmiTX70hT3biWGoKJmjEUTUTIpadx1/5gtx6nTy/QFCJcUIglQuje8g1WsugdjDiHx
         c6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZCd+YWp6Rkdf8GaAemTwPAfWHSubBGbIoqG74NI1ms=;
        b=qSMlqjTG3n9gFHIfdTA7mnBmvHLd0o12lqErzvT+1E6P0YgezzdOVTqTnPibSlyWTT
         yPBCEis1Lbv9Dl3UBtgsNTzens8o7miEzzhZNLAEsFfZjZYKUHmcybfaPQGJaRdGxKDY
         Rzy510qnK9pzdvCuqzlDRtWvFCtkB+bC6ZPPLbp1l1f7ldQoV5x81fXTNz/1wYpdk9fO
         djNt1Rqh+x8lxx0TgifYYqirpGQmxrIELCgya4RqvpiAMVJHEU2eOPaEjwnNBCDHKEcV
         6GzDwPP2kdl7JMf0Qmg9+7Em90VFO1XD1rp3Rtoq6h2b86cnUCcyWrIRU9Mf8SZsTNHl
         +rpg==
X-Gm-Message-State: ACrzQf2xA5BgI9EgofCGK4hO2aHKaelumvC0EsurH9QHyFNM4tioXxt/
	6G3D1hfpmvA2suaOdyqnaYoZAg==
X-Google-Smtp-Source: AMsMyM6RmjeHSSzE4pJtJXoG7Eo99Kdim1xVs2z0jB4XgAle1pf8E0nfbUcXkYLxxP7MtTx96ZTsyw==
X-Received: by 2002:aa7:8d17:0:b0:560:485a:e242 with SMTP id j23-20020aa78d17000000b00560485ae242mr7099026pfe.31.1665782106003;
        Fri, 14 Oct 2022 14:15:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090341c200b0017f7bef8cfasm2127464ple.281.2022.10.14.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:15:05 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:15:01 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v9 01/14] KVM: selftests: Add a userfaultfd library
Message-ID: <Y0nRVTcWGybRAw+q@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-2-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-2-ricarkol@google.com>
Message-ID: <20221014211501.xSP9yqcKHew56YiFZP96MMRdykp9-4LhVRtXF7Je8d8@z>

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> +struct uffd_desc *uffd_setup_demand_paging(int uffd_mode,
> +		useconds_t uffd_delay, void *hva, uint64_t len,
> +		uffd_handler_t handler)

s/uffd_delay/delay, and then this prototype is easier to align.  Keeping the
uffd_ prefix for "mode" makes sense since that might be ambiguous, but like
"handler", I don't see much value in prefixing "delay".

struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
					   void *hva, uint64_t len,
					   uffd_handler_t handler)
