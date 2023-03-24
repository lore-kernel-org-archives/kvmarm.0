Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2DA6FDF
	for <kvmarm@lists.linux.dev>; Fri, 24 Mar 2023 15:32:15 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id f66-20020a255145000000b00b714602d43fso2139471ybb.10
        for <kvmarm@lists.linux.dev>; Fri, 24 Mar 2023 08:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679671934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8wWj5gOBKK79F+U411pw+oLnnu4up+3JeOo4QflJRMs=;
        b=rfTPuN5gA17NBcmwJPvRfjQtsAwpqfGwbNMJ4apghPHh9Sg2/PNhVnwzTOSMs7XI+O
         yZNpqreHm1myeEi5LfJCi3HL+K5brljFzOQATNAvfU7E0TSRQPWDz66fULQF9Vy3rH0O
         RdhVDUVlUrg09IESx+uEy4FRMG/maagZASLl0Bs8lFbID+pnzhWbe4lb0AQbljzkwVW+
         gv6jrsdylvoXgQBjgDOSSmJtsMUlXxDoRX4E8bg2ffOru6PG25wSPjROowJVzI8io1cy
         onmoIVjHPQZeAOqzl2c92i/fMWO9QsajGd8vLJCHMRNDLyEYlnLjRXajBiC7n4hp4/VY
         dAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679671934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wWj5gOBKK79F+U411pw+oLnnu4up+3JeOo4QflJRMs=;
        b=zx3KB/sR//FwIqkBmsxWo9QrMqnwfstHK9G3vfXgoi3XXyY/12PuOeQN0A46NVz14r
         eoL39Wwak1qp+wXvuMrGqhrFN+p0x7lKgCxbI6nVTJtyomcW+jxhNDF73EB9fln2+Gj/
         /3tn3hVBQZCGyuUAwicPWEHZr92g13i2muoGCIJabayd8CwMXo6G7JiTSQWnIYCE9EDY
         uuA6i2xsIWYF7nyNJQ/k3cOrO3l+JFU/bNcvNVGO0A4wJtT4zL9fjRPcMO1GMosz1Wmr
         nAsY31zBnalwktRH9Nyd1UgjE1MuzZDuHPNhs6z9pPBuHN5xjw/6WW7xXwnw5FeefsCP
         zv5w==
X-Gm-Message-State: AAQBX9cTQPF2B9htqzcNPAGSRIJoA7jOogPOiNn6ztmr0pJ66obWITKy
	bxsYSfaRff+hmbHgXhwh9Y0Ch7TfRNE=
X-Google-Smtp-Source: AKy350aR6TmyV8XNI1+jYOI4HteoseM0nrN8Xp9QMAlCHGUU2J5wvQmLvSBl9ObmAQouPC4xvepv2PnYDa4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:12d4:0:b0:b6e:d788:eba4 with SMTP id
 203-20020a2512d4000000b00b6ed788eba4mr1213205ybs.6.1679671934425; Fri, 24 Mar
 2023 08:32:14 -0700 (PDT)
Date: Fri, 24 Mar 2023 08:32:12 -0700
In-Reply-To: <20230308110948.1820163-2-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230308110948.1820163-1-ryan.roberts@arm.com> <20230308110948.1820163-2-ryan.roberts@arm.com>
Message-ID: <ZB3CfO3d8ULSFUwk@google.com>
Subject: Re: [PATCH v2 1/3] KVM: selftests: Fixup config fragment for access_tracking_perf_test
From: Sean Christopherson <seanjc@google.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 08, 2023, Ryan Roberts wrote:
> access_tracking_perf_test requires CONFIG_IDLE_PAGE_TRACKING. However
> this is missing from the config fragment, so add it in so that this test
> is no longer skipped.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
