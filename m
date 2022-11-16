Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C7BD504
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:06:50 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id ud5so45714835ejc.4
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 09:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ntvWgXmyJ+ykqZ+C7I8wJwNPUjVuwRNNvjO3LgHYeZQ=;
        b=ijm23BXVpC91ubga8PZXme39BcIbxyQVTExxRKXLSvZDwSo1X0uMeKsr7Af4VNMN5F
         3NheMhsqE43RygVDM/jqGXonihzTc9MNVlqK3YiBbqPGVwkBhqeJxKrh3IDLPdbivdbI
         5UF69y2Xsi16bX6JXRDlIbeGzG+NFKuoa1rTjK5uI3yc98PJ8r/C7knt4fsZiZaPbBEu
         C+nUdfI+n3I89DEqDmtzg89PBhJJuF2Dzei+N7FTHK2b76i7PNqem+0Dv9w4cD2XuUjs
         tPnFZNspYuymVCs3upZV9M8kNEsHnbByVfWFQGI1a07rLlebliWtUZeAmqqUJl7ny9QT
         lKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntvWgXmyJ+ykqZ+C7I8wJwNPUjVuwRNNvjO3LgHYeZQ=;
        b=Om5IpwLJAkI/Q7wjgdSl+hX5mGSoP8HC7MUV/HNY7yD7jRa/wnoRFKudR5cWwsW5xH
         MBMLP7QTPuV780qgOI70D2XC/a4GtFiK+URpAafxcAQuxOx/P5br5cwy7hEpP7InQWGY
         xiylnUwtds32FdqZNA4oCSMXe6D1E/PrOWRxuugo35meyVZKleezWUKHZLpnFwEc/e75
         C7Tgt32zIABoqFxjGt9wxbona2BWDmY+hEc511/oz2XRbdpQov/a+PvLSyjIqITnnuiX
         TzIYZjyoIWre2PU+mzWZy6n2pjMXLrtCEst5CmClDc4WB40+XhdVKPyVNyRMbtgUkqnB
         FmzQ==
X-Gm-Message-State: ANoB5pncITKI2ffSNemCHb7B4T35pkhpm6pNen/M4QO5+vZbYMkXYY/R
	oOc1H7u5SibRO5ZvKthAKOyJHA==
X-Google-Smtp-Source: AA0mqf7OUgDhaAkgf87o1aEoAM3GV5pr2cWK1jkNVYywr1xdXN9du8Ug6c89/kiZd1oJFyyfqrOXQw==
X-Received: by 2002:a17:906:a2d4:b0:7ac:db70:2f90 with SMTP id by20-20020a170906a2d400b007acdb702f90mr18116893ejb.297.1668618409178;
        Wed, 16 Nov 2022 09:06:49 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id r18-20020a1709061bb200b0077d37a5d401sm7115248ejg.33.2022.11.16.09.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 09:06:48 -0800 (PST)
Date: Wed, 16 Nov 2022 17:06:44 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Andrew Walbran <qwandor@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 12/12] ANDROID: KVM: arm64: pkvm: Add support for
 fragmented FF-A descriptors
Message-ID: <Y3UYpGBlU1W62Mfz@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-13-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116170335.2341003-13-qperret@google.com>
Message-ID: <20221116170644.CyHz-F8m1SQ1-BLpbuX7C6hAVeAIvo5pb3Ce5j1N5OU@z>

On Wednesday 16 Nov 2022 at 17:03:35 (+0000), Quentin Perret wrote:
> FF-A memory descriptors may need to be sent in fragments when they don't
> fit in the mailboxes. Doing so involves using the FRAG_TX and FRAG_RX
> primitives defined in the FF-A protocol.
> 
> Add support in the pKVM FF-A relayer for fragmented descriptors by
> monitoring outgoing FRAG_TX transactions and by buffering large
> descriptors on the reclaim path.

And it seems that I have forgotten to remove the ANDROID: tag from this
patch prior to posting ... Please ignore, it'll be gone in v2.

Cheers,
Quentin
