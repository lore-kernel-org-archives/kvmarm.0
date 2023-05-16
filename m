Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4A320998
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 19:53:41 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1aad5245632so387395ad.3
        for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684266821; x=1686858821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWBO492YYUrIjC7hJ3nSFPMfAcwXlNtVy2XWpYw1CoY=;
        b=HIoRxX64H+DbjHKrlu1aSp9m+D1i+79BuNFn53F+1cckmOhBkvFlP/9ZitZ2fXGYiv
         9naosVE4ajtbM3iiyLD6A0e1zeZwkAtK522+G6D4t8hp87X+HlLrIX7HZ8Cf2sC0fQhx
         gUpsDTRA9IpbMXHHQYKygv/yaXNzzAUdOMGkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684266821; x=1686858821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWBO492YYUrIjC7hJ3nSFPMfAcwXlNtVy2XWpYw1CoY=;
        b=leNv5nfnhngvgw+0uPbx2OHR3iC74BMF3oZx+T0kbUW0pjN64cOLhLCYEpp8N1QwVb
         KdKtR6usMZUFyldoz0BJLt4EZ2wodK2Y2DtByHgLxWUJVYITcrZdHb4+n2C18LOuAaOS
         GNWSfp2kjMHEvV9Xtt/dhC7mbY1aTmzYOaMQ+EjuuJU8b45n2jdGwwl9Hr0QBilevbvR
         +LlrQ9YUho3fKp8LWH9OaIqbOkgHWa8q4XFnxm9cSxBajjSGO3sli65/0wgC6AmGanhg
         BcdxUeN+II/XFLdghb6xxjMHnD2/PNEsbGajbGo4oJNheIw9M+onuEt3fjvREetHIXcp
         KcOw==
X-Gm-Message-State: AC+VfDwHr8tHy9+uOnWMjlpQhQnjCQzvDMeGPrn2pGjOn/CDMFCH6tHs
	dCq2kaaVtGqBjvaFTXcsev9j8g==
X-Google-Smtp-Source: ACHHUZ6NpkYmVwQtlRW58gR36TztF3mS5d3F6fqtF65RhScpaxUfW2fNz4YI2hj/sYhwSjJG2cgW3g==
X-Received: by 2002:a17:902:c94b:b0:1ab:675:3e0c with SMTP id i11-20020a170902c94b00b001ab06753e0cmr51404941pla.33.1684266821413;
        Tue, 16 May 2023 12:53:41 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i1-20020a1709026ac100b001a64011899asm15902530plt.25.2023.05.16.12.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 12:53:40 -0700 (PDT)
Date: Tue, 16 May 2023 12:53:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 00/15] arm64: address -Wmissing-prototype warnings
Message-ID: <202305161252.24E9E9889@keescook>
References: <20230516160642.523862-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516160642.523862-1-arnd@kernel.org>

On Tue, May 16, 2023 at 06:06:27PM +0200, Arnd Bergmann wrote:
> This addresses all arm64 specific protype warnings. As with the arm32
> patches, the majority of them  should be straightforward, either adding
> an #include statement to get the right header, or ensuring that an unused
> global function is left out of the build when the prototype is hidden.

These look good; thanks for tracking these all down! For the series:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
