Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B6D3955C7
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 11:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470098; cv=none; b=jyg96XTh2Ec5qJJ6eKFb4GKAdcSXbc1N0uHHF+0SinBgrIUgnEADd+K05V8zrr/RpgcSct3aWEVWSkIGUW5JlPAVbSs1xA0cP2X5TUHrmKXtuiKflpOF0DQp9ORxTKtX+SOjhxEW3BRuygK70ZTO9b5DY+Ut2eO5qAggh9hDSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470098; c=relaxed/simple;
	bh=gNab9UB/dOuP7n3fh4ySHoj+tcM0Z+lxV3y78kbdIaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QrULtUxZr56U4jZRQN0XbtwrxrJmR4/7d4rMPy4MQtcRoXhfNvUQ87Bv5id3ufkYJio7tP3mpmSg1otRiCE79ptNTyfrnOcLsI+sCOsjoVIXEkDIISODx7TZ1ehBJt6fFHwB2vAjm17DFuMf5mrXAu+1p2ESDElvAYIctUDeDB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YJCw8Mb0; arc=none smtp.client-ip=91.218.175.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YJCw8Mb0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gNab9UB/dOuP7n3fh4ySHoj+tcM0Z+lxV3y78kbdIaM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789470094; v=1; x=1790074894;
 b=YJCw8Mb0o1KCElwmqPwItbu2uQhmIquVW+Os0VmhfHr+WvzF/z3JeQ8ySiPCfTPnssgv254h
 1DhHjDdJNfnLHoK5qy0zWzJNqqB6Icf8rFs6kDvuAkiERiUOn1EpU5rr9D1Y9fktnyQ1loKR6Ps
 vjwC+It0ivq1QFtfMO9Ha4bI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d68f00e5c75ff5fd;
	Tue, 15 Sep 2026 11:01:34 +0000
X-Mizu-Trace-ID: d68f00e5c75ff5fd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so4169e87.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 04:01:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw5ylabV+/kJ5A8jX+1OlYCLFQJ2jyquTpKZWMGUDAFflYtn0G3bdMToqk8Ar5otp6cBou3wHA=@lists.linux.dev
X-Gm-Message-State: AFuF++kXf2EM+LJAEtFa5sbdMndscoA3JZLTiVFK9dGgy4f59u30ehid
	dZnzoMNiwNZH4zZURGJ09iInk5G0AgvtuCRV63khA3PwdTAkcTDce0mTlyKQHUMGw0exfXnFBjU
	l+TawOqcYlB8nRwoNXaWtkiqgGGb3ZgegMOCjzj9H
X-Received: by 2002:a05:6512:ad0:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b8b2d4e62emr154752e87.8.1789470091337; Tue, 15 Sep 2026
 04:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-3-fuad.tabba@linux.dev> <aqkiXqjSZyyqHZ5y@e143914.arm.com>
In-Reply-To: <aqkiXqjSZyyqHZ5y@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 12:00:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx14bh8nPQnNUwsk_hxES2xW7bs9H1MXFHdFKU3Xfgjqw@mail.gmail.com>
X-Gm-Features: AcwNN1Wt3ZBrIQYAxXdUQmdQ9vDJcACZrVELsbuq48nV4nCYU-mL2MgXk9sesGM
Message-ID: <CA+EHjTx14bh8nPQnNUwsk_hxES2xW7bs9H1MXFHdFKU3Xfgjqw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Pin the host vCPU before adjusting its
 PC under pKVM
To: Joey Gouly <joey.gouly@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

On Tue, 15 Sept 2026 at 11:48, Joey Gouly <joey.gouly@arm.com> wrote:
[...]
> * A pin only fails if the memory was never shared, drop the request if
> * it is a bad host pointer.
>
> Or something like the commit message says.

Ack.


> > +      */
> > +     host_vcpu = kern_hyp_va(vcpu);
> > +     if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> > +             return;
> > +
> > +     __kvm_adjust_pc(host_vcpu);
> > +     hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
> >  }
> >
> >  static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks!
/fuad

>
> Thanks,
> Joey
