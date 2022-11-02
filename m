Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599701E9F9
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 16:33:20 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id b5so16697646pgb.6
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 09:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bSpvtaO5+biFCdXjgWOU/VG7HbNWLZ5uq+eRXSvuuCM=;
        b=QFzFFdsD02xgwNnv6w/5D3h0dWbBgJ42EmoGbAgWbOReIP7ibvMB1sHHN5oEGVDyK2
         bk3kncpJvgSara7MPPqv92ajq9XrSKjcvnywOsb4pV2qvmxneWfV7ARhIkMOGJwlrz8R
         1Wwd/25n0QydVBeAVmeDEjCCXnRkwe9F3P5rzk+d4bD1ddvkvul8tu19r92ToFUVyoGx
         nlwWSse6N6Jrp3BrkQdIfBw3LZGgL0c72+hR7wt3XtF30HeXkl7FuQ+WbQd2KaROGHaG
         irDvrqhCVigzw0R9bF16EmQWLdUFa8qhbnJy8fQMwqr8Dq2eNuzsKxKGR7dvUWm40Zes
         M5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSpvtaO5+biFCdXjgWOU/VG7HbNWLZ5uq+eRXSvuuCM=;
        b=hr3bwNN7m7IRxq0j0mBXswaDnSiEI9suqEdL9GiWpv+JQspUozmnrjoqvJQWp2GnHr
         R1/EcmLHvoMXIWR4qhwpkXQBIcyZCMgQErUStdZk5ef34fsSKaeijhjyr9wngwY10uRz
         +322Qf7ae5pUFxRk0NQUdNV8JfY1ajmiYpiQfwrJrtlXfcBrPldfk95IQISdhrgYF1xj
         oVS04wX4yUADyX7hlis1HMFN4VurfTZ1YKmvFmlVXEvoSHptfo15SYPU98iQCjyBA/T1
         z/fCJYI+/ordi4CCLtxT9MKqiDt5Etm9t7tFNHqXOBf58UeF/z3vQT/zMcMwP+72i/Tm
         ShDA==
X-Gm-Message-State: ACrzQf2ZSAbX8t/exjP+wodqR/YiMpxU0oPYMos8zPlDIInKhetImD48
	qaBJd8BxBLivJDBnlAhEfA/sVXEaK3hn4A==
X-Google-Smtp-Source: AMsMyM7/IFIrAzLF68OTsZpwvpWxXuJLq80r9JuhA6FJpKg68htFc94IYvOx1OmW0dUzBtPQISiKSQ==
X-Received: by 2002:a63:fc12:0:b0:45f:a6e3:7559 with SMTP id j18-20020a63fc12000000b0045fa6e37559mr22400123pgi.237.1667406799666;
        Wed, 02 Nov 2022 09:33:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b00186a2274382sm8586776plx.76.2022.11.02.09.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:33:19 -0700 (PDT)
Date: Wed, 2 Nov 2022 16:33:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
	shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2Kby0yXu0/Zi2P1@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
 <Y2KZdDAQN4889W9V@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2KZdDAQN4889W9V@x1n>
Message-ID: <20221102163315.QwPoHxqImO3d9i5xIaWhBRJ0bX_65LJguLBSvfoWtqo@z>

On Wed, Nov 02, 2022, Peter Xu wrote:
> Might be slightly off-topic: I didn't quickly spot how do we guarantee two
> threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
> that's insane and could have corrupted things, but I just want to make sure
> e.g. even a malicious guest app won't be able to trigger host warnings.

kvm_vcpu_ioctl() takes the vCPU's mutex:

static long kvm_vcpu_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
	...

	/*
	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
	 * execution; mutex_lock() would break them.
	 */
	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
	if (r != -ENOIOCTLCMD)
		return r;

	if (mutex_lock_killable(&vcpu->mutex))
		return -EINTR;
	switch (ioctl) {
	case KVM_RUN: {
