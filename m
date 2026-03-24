Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D3838F232
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369982; cv=none; b=mpFFGzBWrqH0wwh9+lVmOaPKdxThFOB/gjmi7xeCW2qDjzJdVPuN1Quj4JQZRDV5tR0BLmZ627dO/5TWM3doAgaMk4L8aTm5GFPcNdtHZ/8sTtfx0cw/oC7MB67sIFpNkTTQW+FGNOHSmjp/h4gTny0J3aUAAD7V15L6W5Gn3sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369982; c=relaxed/simple;
	bh=HaaqCyZJuHFyqaA3jF9mPx4YKb7kG9SBT0R3VHSi6qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aNlPzNPk6kXzNlQFoMlZtDLqyZtLmoym+z+QOSpTe0dmb6l+BL1LipskbXzIzX/aLz5BrQP4LZxB0FexSdqXpN5UolUMyuvsIp+GxQPwItUDMUM9EuK10H1wbMZpPm0pw+eEskFuGlSk7SXSeEwPjS/ig6Ug0eQZd9QoRphKsjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQpGi7Yn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQpGi7Yn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774369980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HaaqCyZJuHFyqaA3jF9mPx4YKb7kG9SBT0R3VHSi6qg=;
	b=cQpGi7YnVwYNCw9+xr1l7EckHsNNTM5lzbve9xVtout++4FE0kU7nacVpQWQB50FVEwUeN
	uFYayCWcgcuQeB90FAEXxx/FCxkZ/3BX+aPK4a5AFVDpBA7kKdmSqq8ZuDlUh9jVHDJ63E
	j/Rjo4BIft7lgpjfDsbhYNmDOglon0c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-vplSTaCpO2KTspvLe62MIQ-1; Tue, 24 Mar 2026 12:32:59 -0400
X-MC-Unique: vplSTaCpO2KTspvLe62MIQ-1
X-Mimecast-MFC-AGG-ID: vplSTaCpO2KTspvLe62MIQ_1774369978
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43b86de58d9so493391f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 09:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774369977; x=1774974777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HaaqCyZJuHFyqaA3jF9mPx4YKb7kG9SBT0R3VHSi6qg=;
        b=AZAtACzf62y+mtcZF35+BIPQJCL/qB8t1zO3GN12clb04O4N1BqAdAKwGLX4WpOXEt
         bTMBLYHnVV7VMxpHXHmYeusOFT/mVbeIvFa1hnTkf/X3ZTjYGTNDqZQMvEBhOz/NKyYA
         Y3KRX8zOHQ3wFmvTK6BCO+IsQf74ryCaemtImZMuJ/PDDU+R2QQzeL+ybRvkYnliAD/k
         tFPCfPKFw2Pyvv1OPEfJvNW8jlB1/M6NT1Bom3EXmvRptscPrEXXoz7D+d6fBwACD0qs
         FnG/2PW1wPgwVOrwoGWuJ4/EDF7Kshya3zH6zZAuT/Z4xa57VJCGxFbs4L6C3bHq7tAw
         XeWA==
X-Forwarded-Encrypted: i=1; AJvYcCX0pWXJ8JxzFTSdfgsy+Me+gCUOvNz/DK8Cv5x75WUYevGCdSWTk/KRSKzjNqFF4dEeuaD0hC0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx3zU+cMdyIYpEBILga2yykHK/TEcUvzv6jwThXjC14eDk0MHP
	I6I1KzZrarBFERhPlPtXGEJ8y/bKbi55Fqfl8Nqzr30+zKA7I+T8mUaBcpp+l8enNfKmqsEzKCn
	LwNMB8hirJYh/x07uq4zuB7QMUqC09CjhIMvghY1Z3QDsBu+A6iBu3Q3xXieFXGfssNI4GIosOA
	lkFhOx7f0BCRQYAMc7xUvHC3e7g1NIy3CHfGaDfvyP
X-Gm-Gg: ATEYQzxGdrw0L7Pn4bvVAHRNIoJgJkBNPqMYVHUmROT8uJyGUbcUMzthZ002s6FVuW7
	HBWo+DEi/hR5JSpnSF2FN5gcbzQ2lQ4pWvWtWoHPB2E8STo7ATSxR/EPkAKaNOFQGP+CSZkVqlb
	27n8b7BurdUKk3mTrmc8yuAR0jIR64aycwzVH7IRE7kk+ZsFnFYpSeEWLzyDC6/dn52oPXNyNeY
	I7I3/ZWEESwTO20ilXasEE4pnHNW3EcgOWcgV25u+/fXkFFGsn2MubsBwhwpXJErvX6e5IwDAwj
	1dv6
X-Received: by 2002:a05:6000:2003:b0:439:c040:cc8a with SMTP id ffacd0b85a97d-43b88a0fb2amr191790f8f.32.1774369976888;
        Tue, 24 Mar 2026 09:32:56 -0700 (PDT)
X-Received: by 2002:a05:6000:2003:b0:439:c040:cc8a with SMTP id
 ffacd0b85a97d-43b88a0fb2amr191746f8f.32.1774369976441; Tue, 24 Mar 2026
 09:32:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260320094151.2541661-1-maz@kernel.org>
In-Reply-To: <20260320094151.2541661-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 24 Mar 2026 17:32:43 +0100
X-Gm-Features: AQROBzBSOb2DrC9P9JRJKnQIuo8-0o7xFzXZcGC7UdoeyqQYcpLh-BRplqsjmsU
Message-ID: <CABgObfb=e4eeD7Dx7o_3rSNvs+dGmoE-n3Zp9N6A_QTzGtjVBg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.0, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X7s-JJ2xHWfFWX4k8d7Oe6YT4oluRr3MImfHe3KqPqM_1774369978
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 20, 2026 at 10:42=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Another week, another set of fixes. This time, another two fixes,
> mostly observable with nested virt. The first one results in a vcpu
> coming out of reset potentially skipping the first instruction at its
> initial PC. The second one is a classic example of pointer arithmetic
> going wrong in our address translation emulation, setting the access
> bit in semi-random places. Both are stable candidates.

Pulled, thanks.

Paolo

