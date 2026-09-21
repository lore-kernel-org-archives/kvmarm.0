Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C851F3E451B
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 10:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985424; cv=none; b=d5A8v7bu2TVCxWKcMhrVhyyk9M6rXpP+un9xLW3wSF0Ed1dIhSovWEyM7BLUYwQ0ax9sIksPo/Bg/Q2mxAdv5bxV7VvMg3WKm2EBrG/DYufGQCv5nqd29mcKnVr+FDNIHa1Y9y3GLXFxq2l1rdVvqterv8IsWwYmZVYdpMveg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985424; c=relaxed/simple;
	bh=v0P4ayQReWgnEDJQOUIqGqH/JIvX4Upl7U9Sz/eEyJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ms920Lkm5uOmkpjata97JAC2f15BYENpNhoX5XrICeiOoxXVp7aDceEwHS9D8gjqNU3as8zc85hRUn/4Ztv+Vus68w0NgeZwOIFY90PPTaekXk5S8YaidVO3fG0azEa1cS29te0uHbsPhwCVpV7TeP6OvKkp4C4Z0XNz/akbT2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YcCYJyCf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YcCYJyCf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789985421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YA3vQgRKFGawP1ePJiuBgfbEVZaFG6kWjdLmIbJG/cc=;
	b=YcCYJyCfnFUed2mgr/UqsUeBImA/JWi+KnmCKyl/AIiWu+W/4G9wZG9LJdcCXNqE1TURpN
	7YxKD+GdE26/g/N9TtSGopF9CIK5Z0TpyjeSc0L48AWZK9tlBShalwjj2Guy+1MjlrORcI
	hLwL7c84lxYaaOomnFrCs1kYju+/rIA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-OnvV6xdyO4KhUZRc_oW-vg-1; Mon, 21 Sep 2026 06:10:18 -0400
X-MC-Unique: OnvV6xdyO4KhUZRc_oW-vg-1
X-Mimecast-MFC-AGG-ID: OnvV6xdyO4KhUZRc_oW-vg_1789985417
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49cdc4080ddso15687055e9.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 03:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789985417; x=1790590217;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YA3vQgRKFGawP1ePJiuBgfbEVZaFG6kWjdLmIbJG/cc=;
        b=SpHHU6heZ3Sf4KuBX3B5gs6NPzvl5s8w2y7iutN6YmUWMrQPB7aTUIgOrJpB63Pggg
         DZj4Ezor3YGoTQzwmJmigZ6oMycbOxHgnfBv3Z17OsJHa69jKU/mRWoK3RuGOW1DgktP
         C9FJmbfnBrhcwBRxyGpRFJm6oNt3wt0swp9jelNHLiPtwyVtPRhvosB9pffK+EsqomBs
         MLAzMI7Qb+17/lfWwsGNPm0jSMBPkDfrIm6+6ObTvIweWeoeILcklS8lBio6ggIhjJ+Y
         DpAan3ub6EZuMZdjkcLD/eDgZVKMv74z8lKsyTZFP6B8iFJZie6ZAnBvVM0LlLL3WiKY
         3Png==
X-Forwarded-Encrypted: i=1; AKwUvByILHBvrR5qQr0QJiKVznQGH6Hk03SmDUxY4qV2psfXZ0v7yOmZhj1uCwJol+GwOl+Mu1+18Ik=@lists.linux.dev
X-Gm-Message-State: AFuF++lDVU9KaTeVIGkXem5xLgxRvu0rOY4dQvbFxbjj7ZB9Oivuf5/Y
	/14hbO/6u619UetccQ6v82c+9xKmf9OtEl8/v/4nwEqWLeyIK7Aq1lWuxVJVuMHvUTcHtff7x2V
	9Zg5mTiECuHgAL+/rXb2Mni5ZQ8vE0Mz4JZo0BevZibN0croVmsgSaRakjrx+3xE3840/52CJiw
	Wz9o3ANdpsgJPXqcOPgiDfYe95iCK4dPhz
X-Gm-Gg: AYBFou1cjOaSRwNKA2zhKB8UYih3OTxo/AlTdicfky5iw8igEp/Un3aVzFiyTvbS9uZ
	z3CByl603e214SCvgcBpSyV3EcLY22NKCHidpupu43yw8euqXx6iaducGkZB0lBX0hnZa+Zh0C4
	SWt2Hpwtwpcp1p+SbzPAlqJ2N0CHx69WmhSw+jlBj/o5whuddWL5Bt9rKVwtXBlfravIPFQUJZV
	/c1fzBFYgePsZWVSkCQiU+2HGtWdtOGWwNYfpR3umkKuGfj6uM5nxdc9Jg0mA==
X-Received: by 2002:a05:600c:37c3:b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-49fc4f8528cmr144125045e9.4.1789985416916;
        Mon, 21 Sep 2026 03:10:16 -0700 (PDT)
X-Received: by 2002:a05:600c:37c3:b0:49c:e37e:4389 with SMTP id
 5b1f17b1804b1-49fc4f8528cmr144124745e9.4.1789985416539; Mon, 21 Sep 2026
 03:10:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aq7ViMljbhjibseX@kernel.org> <aq7WIW052XXHJWlL@kernel.org>
In-Reply-To: <aq7WIW052XXHJWlL@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 21 Sep 2026 12:10:04 +0200
X-Gm-Features: AcwNN1XAAsJ94cGxHRMtNqiGnGs3RDz6T6V8oXiFTADje5gE4RX36YH8CZ6l8Ic
Message-ID: <CABgObfZYa8uwsAgKnr6952qMZf6jjf_AsJBmxeS8zYLLRSGD_g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.3, round #1
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S4sDYK182aqmxb6C_Q2rB-HE3IQOdl0WsCB5ADAODj8_1789985417
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 8:36=E2=80=AFPM Oliver Upton <oupton@kernel.org> wr=
ote:
>
> On Sat, Sep 19, 2026 at 11:33:45AM -0700, Oliver Upton wrote:
> > Hi Paolo,
> >
> > Here's the first pile of fixes for 7.3.
> >
> > The diff is definitely on the larger end, although this is mostly
> > explained by the inclusion of a selftest for the ITS table changes
> > which are quite tricky. Also worth noting that this selftest mixed poor=
ly
> > in next with Sean's PPC selftest prefix due to the library changes [*].
> >
> > Otherwise, the most noteworthy change here is definitely the pKVM patch=
es
> > to unmap the EL2 hypervisor's stack pages from the host, for obvious
> > reasons...
> >
> > Details on the rest of it can be found in the tag. Please expect at
> > least one more pull for 7.3, there's some additional changes that are
> > still brewing.
> >
> > Please pull.
>
> Haven't caffeinated enough yet.
>
> Just in case it wasn't clear, this is a
> conflict with 7.4 material and based on the conversation I expect Sean
> to work around it.

Yep, one of us will handle it.  Pulled now, thanks and sorry for missing rc=
4!

Paolo

