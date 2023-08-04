Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE9F1AA87
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 17:27:10 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-585fb08172bso25882617b3.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 10:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691170029; x=1691774829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0XNCE0THmMSplRGDYFiIYwKZfHJYXKQUWjyM6yzp218=;
        b=ioU7Xhc/g9qgs9gG71lCacbcGZecZKnk09it5Wjzn2tVrX3fgSS2tCjX0UJGYNzPJl
         eXFA165dQDgVzSZPWS4dcgb+pPYBrcGh026AEPvE4uNbDgNrYZqkNSkaPZKHcTUKmwBm
         dxsmh7ephRFh1G8wQbMJXhfximF2cj4DhGKNHDjqaT8r9l6r0sL1PI0zouj9bI3atq/d
         IJ/yKmmEQrpgHKveDl5xLOedKR4ibfnJ5dvcOMP6fyU5qYsTyKBHRxxsn9JabxZo6zog
         RWwC/HqKx9pD1TcDTr3AH+U/YQ8ltr1Mrt0ZsbH+vNJ84ZndKhmF1NaKGmBGEAxeCDzw
         LOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170029; x=1691774829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0XNCE0THmMSplRGDYFiIYwKZfHJYXKQUWjyM6yzp218=;
        b=HZc5Z9/9JmRX2js214/h/8JqYagyvWhLFS1ZDhaHGl6B47dJs5VcJG4il8rWFDNoJK
         YS+xINWBjYeA9Wfr/5weBEA5Q5n1SRNvgoGRgU50EOLJZLpxuCBaScAER+PR5GbACzc9
         z2bfG6Sbkb9e6UyaCraIQnuQikxSMMG4QiVnhcq+hIZtxKyQWzPHdIiEhA2gmPa1HHTT
         pR8efciAm8dfZ0fpTTETIJc5RvTu9g+j5pXR0xNX/G5HgNBRn331R/XRIUAs0us1vW11
         drGB7eWv2BHHQQ4WbEZNQgtUaZj8eXG6EfJLp0PXBnDe7Sfk+uK8sK/CwoGV+DusQyUj
         r+wA==
X-Gm-Message-State: AOJu0YzKR0+qQ2/iT6g6q5++33ikBZ/PoXj/444iqmgL4sBXszH9+Ipq
	Ya5zvSPy4kDRtoij80mXBitx0p9lj3s=
X-Google-Smtp-Source: AGHT+IHY1jyESYvdqjtEUOWN5kpmBlG2/bzs9/bKSXZUMXovofE5m64qKwapLGFKQLq4x4vgTmvsT5rlOJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ef12:0:b0:583:491b:53d3 with SMTP id
 o18-20020a81ef12000000b00583491b53d3mr15983ywm.9.1691170029578; Fri, 04 Aug
 2023 10:27:09 -0700 (PDT)
Date: Fri, 4 Aug 2023 10:27:07 -0700
In-Reply-To: <ZM0rXgKvb912k5BE@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com> <20230804004226.1984505-3-seanjc@google.com>
 <ZM0rXgKvb912k5BE@linux.dev>
Message-ID: <ZM006zd4bpsGBtWF@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Add helper macros for ioctl()s that
 return file descriptors
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 04, 2023, Oliver Upton wrote:
> Hi Sean,
> 
> On Thu, Aug 03, 2023 at 05:42:24PM -0700, Sean Christopherson wrote:
> > Add KVM, VM, and vCPU scoped helpers for ioctl()s that return file
> > descriptors, i.e. deduplicate code for asserting success on ioctls() for
> > which a positive return value, not just zero, is considered success.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> I appreciate the desire to eliminate duplicate code, but I think the
> naming just muddies the waters. TBH, when I first read the diff w/o the
> changelog, I thought you were describing the input fd (i.e. 'kvm_fd',
> 'vm_fd', 'vcpu_fd'). I don't think explicitly spelling out the condition
> each time (i.e. ret >= 0) is all that difficult.

Yeah, but it's not just a desire to dedup code, I also am trying to funnel as
many "ioctl() succeeded" asserts as possible into common code so that they naturally
benefit from things like patch 4 (detecting dead/bugged VMs).

I agree the naming sucks.
