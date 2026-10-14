Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55683B5F50
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997018; cv=none; b=g1uvS9ErZDKsYepbB3pCIUTKS/CXnNJtQvKmNYdUSiKv0MIHjGcv297MZuaKfepDb/bzNRyKIOm1C6jad2Y24zCBbwcj0sq25FB8XHHJlNKAsj1X/0XvXm9dL8LW4WiJa0VfFVKNjogtTyvr8Ltakl3sKN4ocIp7nyMt3/lhF68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997018; c=relaxed/simple;
	bh=lBbwIvFL38lVOZots084p2b19l+FJ0sPwwv5pZU2vv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNW0lSQWdSoGtQ/TOSGJUu/L/2C7m4KKlM9x6ztiIvla/mDvq+tTMnuhfiDY8mQ231fg+xgDaOtKU5ewxw5Up0zoo1tQH66ho3WWatzmWP4H1i05c5VdgX+muQr5NfgvDMhqkErsuX9kDlYSjrxXo913iH5irl6O4aB6u0R9JvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMsih2rl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMsih2rl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791997015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBbwIvFL38lVOZots084p2b19l+FJ0sPwwv5pZU2vv0=;
	b=UMsih2rl4o9TGA6dDeXu+seD6kcwyUGevgQiMOJn9lAokkyGWEyjuOKKsT0HnjxBm6AO8w
	EJp1+GNDt3hNIa6x0Q54MvMaaIXYkEOqSeu4gbohra3IQnZo+WTSEZkmwWQde1KPjFZx+8
	2yeSbW3iUG7omeW2ol0jks+p7yzZ7tA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-RO_OJ74LNPmml9wEKbRpDw-1; Wed, 14 Oct 2026 16:56:54 +0000
X-MC-Unique: RO_OJ74LNPmml9wEKbRpDw-1
X-Mimecast-MFC-AGG-ID: RO_OJ74LNPmml9wEKbRpDw_1791997013
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c6a1d4034so3884045f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997013; x=1792601813;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lBbwIvFL38lVOZots084p2b19l+FJ0sPwwv5pZU2vv0=;
        b=QwvNSqsNgJRTULtcAbn4khEuFjKa2el0Y9qoQxJGySEZJohnBfPJxh27tUhYbZyVCe
         Zw05XMZO5B+No9/zPGwB/p7nf59n+/fPRpY6xQ7cxKmUKxJK1MsAo8AvuV2cFOa0AvNW
         x2oH27rj9SGVKcxitk9/7dMcHvB+e/h31RaEP3r8jQxzMEaNfp9pSyII6fbSQZROVOEL
         vig1Hmm5/to52kvGM6TX5tZbIb+PLqcrLkVkHzhqvI3kZm1BiZJ5Glc/AJYSnIQLMWxB
         EUVRW+x2fbBp7K//eePIsjylhp56hMbPKeqy8fCIURauEz2Fx7aAzQqKZfj06xDtbS12
         YGAg==
X-Forwarded-Encrypted: i=1; AKwUvBxTZNTqgYUYFa1FRlH4BDbBjogk89LDkm1xXHnJjlWkHUOSyhQRGM6A9ycSvptvahDRvZXVn6Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYIbKBfsc/VXuSag6FIlPms9pfJSZ5HGWWlTD6vIJWh9pWt3cp/i
	1vANxONqW+d0Q8r+HB47MspVF+4JRkxQa8yo8ybX3QSCUWndVtsJUhyTj+LLKmb/doAGJhfayAD
	hBTk2Eu+AIIw4z/6xOHRXhYDxUWy06TxaWmBGAoV92CZgaMv6o/LBXLWwbSoP4y4hgiRe/sSj9h
	fZVQpGzTtnpCeXPQE4i2BIo1K666Pu7mIy
X-Gm-Gg: AYBFou3cGks79MdHcx8miRYqi7YfjmK7kRrrPn45EE63m38zqvcx49bG3FEfsTy3jK7
	FJWPTYTFBrY+D6PdzoCJP+xcfWmlZrVCwQNBbfYuG1bR4CjsyY8hgEBT8kwGssohdZWj1lQaI3e
	Id5loWgWsKOnEtEO4gomaQ37x5IZNYDBjpUeVYJglDmKTZi3eUcpkkjM4apUvPx8EWWbGhUyGnk
	68eRRNiSPoLl0H6afSR2JC/CqNnSXk9o+LLHObKN9qn2wA+2INISn22X5mxEQ==
X-Received: by 2002:a05:6000:98d:b0:48c:4a62:9af7 with SMTP id ffacd0b85a97d-48dbaae9e03mr28722513f8f.28.1791997013269;
        Wed, 14 Oct 2026 09:56:53 -0700 (PDT)
X-Received: by 2002:a05:6000:98d:b0:48c:4a62:9af7 with SMTP id
 ffacd0b85a97d-48dbaae9e03mr28722461f8f.28.1791997012865; Wed, 14 Oct 2026
 09:56:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261014162126.964330-1-maz@kernel.org> <CABgObfYVHtFGopM=vCY2vt2N-CON=_5BN4YFiZknwvyrgP5mfw@mail.gmail.com>
 <86qzhs1ay2.wl-maz@kernel.org>
In-Reply-To: <86qzhs1ay2.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Oct 2026 18:56:40 +0200
X-Gm-Features: AclHuK9xgAQ0ZLzEzprl5qRpMX_n6sDrLGVAFdnCLrhAZow3Alf-LuTpAdZdNuU
Message-ID: <CABgObfbkbEY_MuD7Y=Y1GYSrHjp=nKfE8-Vy+QHqKMyCVurJ9Q@mail.gmail.com>
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
X-Mimecast-MFC-PROC-ID: cHhiGvYaYAveGLqbtAeL7ylR08LGwmHP5osQs8UCxDg_1791997013
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 6:52=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 14 Oct 2026 17:30:50 +0100,
> Looks pretty good to me:

Good, applied (I idly wonder what the x86 maintainers would think of
KVM growing a memory allocator...).

Paolo

