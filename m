Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FF9560ACD
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995472; cv=none; b=oSuWXqx9C3yh35Bw7szNo1dBdvAzg+DMrb9LMhKqqpCo5+ZCDknyDhnr0YQBKC5BNVkx0f+UEBbJqjdvXGgVu4DcjZdEpOyaObeFgOW+QOa8vx49n69QJ3oQJVgkq4VXqd799teuyvSYQPtWVyr+BzECf0k8URh/51kPtk8xn5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995472; c=relaxed/simple;
	bh=zy4EIi1Qm5ZXQfZQEHtR5SJYjCSsE5RsXuRQofIIUDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tf+rAbwFqCxZbHzidJdcDF6XfYWjpNRSf0Z0GlKeSE79zhJyKSV4l6g4pkhS9h9DxdDrIhrhT+AfrYpKNo13SdCF5JzhDryZTYJdGrbw+gecgrTQuL5vFGQ3NzumUdewiLZW6b/Vr0vUhbpTlht9KWcd+hG73lD2h0ErK69xP40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FG7YTOZ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FG7YTOZ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791995469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k+0bbYBp5vS6Wzy92SxhIlT3F+PvYBDU5sICwVgEKDw=;
	b=FG7YTOZ4eZ+EPp2lNDntur9U/hTZQw7c1KtCkh3rOu2/HVl8HR2sdbtDR01pTFG4YHt8RS
	JSTu/fcH0atdbekX7pHaYqJWQYFpxh/7ChVmX41P1ufJqMYfrLld0huB69kjdQWVMGy8cC
	685kmKpoWS8iBkbWb/hYN79agQwt4N8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-e8DMIP9zNq21mGaSOP9ItQ-1; Wed, 14 Oct 2026 16:31:07 +0000
X-MC-Unique: e8DMIP9zNq21mGaSOP9ItQ-1
X-Mimecast-MFC-AGG-ID: e8DMIP9zNq21mGaSOP9ItQ_1791995467
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48c54e690c5so3223471f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995467; x=1792600267;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k+0bbYBp5vS6Wzy92SxhIlT3F+PvYBDU5sICwVgEKDw=;
        b=PyexsAjQa1/mOHZWdE2G8Kx9I1k2FsH4Eq/J7Khzl83EzJ+JYHUGt+nNzMlMd1pTE/
         xJ2pRag2txDczkpw+L6Ad+ZDu2lf8jEWWwGnDqmUZ7y29hUZWMat+cJgtz3EUHUGvPhi
         LDchBxzUBkQiDSaJoNLTodeH4rtW/Rl+aGaqdc+eyxUp5TwU7eKpcPtIcUwPFWEIGQj+
         w5xaWPv562xBkFDSFqgp+hC559ndlhy3wDtCoincJ82jLfx/qPq95NVK+Zsi6Kd2m+D/
         a5lgXf204rOmays0NqdNWMuE8jy6smLMRB/LQTmrN6lmnAi+0BqbepjGaQgmO+dDJdyt
         ezaw==
X-Forwarded-Encrypted: i=1; AKwUvBxwvfaMo1qhpfDaEDfQ2v0w5wqz4fVbYtYGlIeL6LZq9abHCx/OltpTneh7crpzoyk5qxIudFE=@lists.linux.dev
X-Gm-Message-State: AFq9FYIgD99pkOemi8jPSaZT39xK3Oz3wsilXorLgAZOXdZUF/mP3rBF
	MQoUOI3Zfjk2OaIXnnsYql2/sggLfSlCi98WD8yiN/qQCvhxbFL/Fuyasc5QLJShEuOFPUIm7Sv
	nUEc6lxCpHKlNz44gnB+EU0S2X6x3YXCYQtjmLEEYv6h06ssDXWRjAiJu7A+qloJBDLMk7wnKgF
	uc1eAyZdKaLcCMzlVaaZKLg81Vq8TOA8Td
X-Gm-Gg: AYBFou01+mPZ8+zuvST+4lA7JjCisvJC7lpayAFQqltT8gWHVBE3U+6FIJ2VqmkIFhM
	AvZqlGDgE0R5phedTiNr/s7qrRad8fAWinK6tPbIwwC0CfuCFW8octuSlJw/DFNzq4GleYoadYl
	ivfQjAAF2pwLkJT+MdbdMm8VMRb5BLYnYZa5FYCakpioWTOkMcHgwrJ0sOr6h0DzRg3+d4b99N+
	ZO7+X6d+xV1RHbIoCnVvhoelolgbX1lb4TE6Tz+UyIWaDq0zK1AVapdh16m4A==
X-Received: by 2002:a05:600c:34c4:b0:4a1:b027:99dc with SMTP id 5b1f17b1804b1-4a1b027a161mr98309535e9.18.1791995466696;
        Wed, 14 Oct 2026 09:31:06 -0700 (PDT)
X-Received: by 2002:a05:600c:34c4:b0:4a1:b027:99dc with SMTP id
 5b1f17b1804b1-4a1b027a161mr98308215e9.18.1791995465797; Wed, 14 Oct 2026
 09:31:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261014162126.964330-1-maz@kernel.org>
In-Reply-To: <20261014162126.964330-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Oct 2026 18:30:50 +0200
X-Gm-Features: AclHuK-uduyx1V7w8xPq5hTQncfjGaYTAtLpmbc_jG8-KYLjkOQH5FYBRTis6z4
Message-ID: <CABgObfYVHtFGopM=vCY2vt2N-CON=_5BN4YFiZknwvyrgP5mfw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for Linux 7.4
To: Marc Zyngier <maz@kernel.org>
Cc: Amit Machhiwal <amachhiw@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Eric Auger <eauger@redhat.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Gautam Menghani <gautam@linux.ibm.com>, 
	Gavin Shan <gshan@redhat.com>, Gokul K <gokul02k@gmail.com>, 
	Hemanth Selam <hemanth.selam@gmail.com>, Hiroyuki Katsura <hk590@cam.ac.uk>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>, Jack Thomson <jackabt@amazon.com>, 
	Jiaqi Yan <jiaqiyan@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>, 
	Jonathan Davies <jonathan.davies@nutanix.com>, Karl Mehltretter <kmehltretter@gmail.com>, 
	Leonardo Bras <leo.bras@arm.com>, Like Xu <likexu@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Oliver Upton <oupton@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Sebastian Ott <sebott@redhat.com>, Shen Yongchao <grayhat@foxmail.com>, 
	Shuai Xue <xueshuai@linux.alibaba.com>, Stefan Teodorescu <fane@google.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tharit Tangkijwanichakul <tharitt97@gmail.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Wang Han <wanghan@linux.alibaba.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Will Deacon <will@kernel.org>, Yuan Yao <yaoyuan@linux.alibaba.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AV9N2RXwor6Il4FXqTnJq1dsPndBH8n5x3lJMV7m388_1791995467
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 6:21=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the set of KVM/arm64 updates for 7.4. After a couple of
> releases mostly focused on mopping the AI wave, we're back to merging
> new code, and there is a lot of it. Given the size and the conflicts
> that this generates (see below), I've decided to send the pull request
> early.
>
> Details are as usual in the tag below, but there is a few things to
> call out:
>
> - a lot of pKVM updates, finally delivering on the isolation promises,
>   thanks to Fuad's work on upstreaming this stuff.
>
> - the first stab at sharing code with s390... More fun to come, but
>   that's a start
>
> - More GICv5 code. As always with the GIC, it is huge... But for once,
>   the code is much simpler than the previous iterations, and also
>   comes with a bunch of selftests from the beginning.
>
> As a consequence, the diffstat is a gold-plated pig.
>
> Things to note:
>
> - this drags the kvmarm-fixes-7.3-1 tag as a way to resolve bad
>   conflicts with some of the patches
>
> - there is some additional conflicts with 7.3-rc6, due to
>   kvmarm-fixes-7.3-2 landing a bit late. I have stashed a resolution
>   here [1], which you can either apply if you're basing the merge on
>   -rc6, or mention to Linus as you send your own PR. For everybody to
>   enjoy, I also add the resolution at the end of this email.

I've done the unspeakable and pulled kvmarm-fixes-7.3-2 into kvm/next
so that this PR will go on top; that conflict is too much to send to
Linus. Please check in kvm/queue that I copied your resolution
correctly. As soon as you confirm I'll move it to kvm/next.

Paolo

