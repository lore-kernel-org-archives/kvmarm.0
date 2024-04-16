Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FE517550
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 03:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713238001; cv=none; b=pvMvKmq29/ezhVNQf3EDeWZx34gFU5xIgWNW9Z+k30GCy0M7MgoUM6gh2CO3FVez2RktvwqgOWtmKChbmlYS7rdJeumHV3q28GDwe+5TaQC/YFvcJwXrQ2P0HwAZlRQVVl3BPArkAjVJWMxxk4reNywzxS3nKT4tootOVFSgKzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713238001; c=relaxed/simple;
	bh=mSo87wrI4SUul6dOUELPanCj87ouMVYaGJuolIWl2OY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=SfNf+f90h2o5m/1Hh87KRfYQVW9+QA6o6x7eqC5JyJEGbjKJqlmhHPgp/plFdKffnUnHODYtTyu8CtXk0YjDfR2dBkFSXcliS2bKYhIJIwnx0w5Jkh+SR87OITlV/XF6hbSq2n9EzY9P1g316QPGV8I/qcipWzHRZQtfq+SZ7/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2xKsBWM; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2xKsBWM"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5e4f79007ffso2646814a12.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 20:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713237998; x=1713842798; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1fKVH44Qpf52nV3xcVtDJdI4iDiW1jMW0xvMeM9U7A=;
        b=D2xKsBWMKUTuR2rn6WxvkmIoE3ZX5Gwfkkd+OEwxK/gfOG3451F0OvL0B/eP0CRKuR
         ojyqZcFyZ7AmkctUz6j/X4ZCd3PvObUSek9p87FN6xhLkjktCoDzu/ZOgkUx2p8fngIS
         Zlrj2hwS9C6vwpS9B1nQJyR7H7oKCKrLf45R5GVEoHmmrKWA8YvCS5/Rzc27nMHSXnoR
         XtWUmUd+G5DnYfBU4+pNFigCallAQrjQIYBhsO+P//P7PZOjsKPYSI1Ul6n65ZP68ULF
         M4ntlsWhSsMTIucchNA6LvueqgyCB2M9b/NRLYNdhztRo8v/0WTHeEyrqMWGjuQKBFdV
         JrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713237998; x=1713842798;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V1fKVH44Qpf52nV3xcVtDJdI4iDiW1jMW0xvMeM9U7A=;
        b=DvIQRBrgQ4KwJ+GD99SVuEmxhdzgPKpPDQ6AU/WdbqvljGvq1234c+gZofVsyBhzdH
         YC/49RdWXoBLvU7y2HOSS+mAPcOXsXB4n4kYZXi0Sz2BN+uq4AEgTPynHpj+s/oC60EL
         8iZRe38LHylDQnhn4YcLKqlJQHThF2/sjegBjeYQ6NZOpf/peb+lsJCc8L29UaE6CyZe
         AndiAxjCJwXa7rDNWAFhBpswpkTSOqcqDlSO4L8sT/Ldlu2XNhuHDROuW97VRbn4Z78D
         AzmT8NqbSKZ38xxrEpugcMHBbZ19eM2fEein46NXI5DR0vXwdfx6b3v0WBQxhB8I1/x6
         VB8w==
X-Forwarded-Encrypted: i=1; AJvYcCVoohfqgHFI2zgaf+7eAimR53bNRXveJfa9bCMCx7FToT16Djw9MPTE97T+oOLPiClHcO9GJU/VmT14fO1z9mZrFFoTDM4h
X-Gm-Message-State: AOJu0YyGki5TLXRcSq4tZN961+Fh8OzmDfXMr0VhPFFSwkmWUmi/Ys+u
	vHiq7QXbmn+pPxIa8lHWN30WFwptCXuDx40rYVcw20SFwCQyavmE
X-Google-Smtp-Source: AGHT+IG5x5Eh/Udr2OWTDSmF61V8WPyGJpOzKZ0mm5b1COfHDZpLuwTMMl+u7FXvmjLfRKTR71F77A==
X-Received: by 2002:a05:6a20:718a:b0:1a7:51e1:258c with SMTP id s10-20020a056a20718a00b001a751e1258cmr12219760pzb.61.1713237998278;
        Mon, 15 Apr 2024 20:26:38 -0700 (PDT)
Received: from localhost ([1.146.57.129])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b001e4753f7715sm7263967plk.12.2024.04.15.20.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 20:26:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Apr 2024 13:26:28 +1000
Message-Id: <D0L86IDPMTI3.2XFZ8C6UCVD1B@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>
In-Reply-To: <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>

On Mon Apr 15, 2024 at 9:59 PM AEST, Thomas Huth wrote:
> On 06/04/2024 14.38, Nicholas Piggin wrote:
> > Tree here
> >=20
> > https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck
> >=20
> > Again on top of the "v8 migration, powerpc improvements" series. I
> > don't plan to rebase the other way around since it's a lot of work.
> > So this is still in RFC until the other big series gets merged.
> >=20
> > Thanks to Andrew for a lot of review. A submitted the likely s390x
> > bugs separately ahead of this series, and also disabled one of the
> > tests and dropped its fix patch as-per review comments. Hence 3 fewer
> > patches. Other than that, since last post:
> >=20
> > * Tidied commit messages and added some of Andrew's comments.
> > * Removed the "SC2034 unused variable" blanket disable, and just
> >    suppressed the config.mak and a couple of other warnings.
> > * Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
> >    the fix for it.
> > * Change warning suppression comments as per Andrew's review, also
> >    mention in the new unittests doc about the "check =3D" option not
> >    allowing whitespace etc in the name since we don't cope with that.
> >=20
> > Thanks,
> > Nick
> >=20
> > Nicholas Piggin (14):
> >    Add initial shellcheck checking
> >    shellcheck: Fix SC2223
> >    shellcheck: Fix SC2295
> >    shellcheck: Fix SC2094
> >    shellcheck: Fix SC2006
> >    shellcheck: Fix SC2155
> >    shellcheck: Fix SC2143
> >    shellcheck: Fix SC2013
> >    shellcheck: Fix SC2145
> >    shellcheck: Fix SC2124
> >    shellcheck: Fix SC2294
> >    shellcheck: Fix SC2178
> >    shellcheck: Fix SC2048
> >    shellcheck: Suppress various messages
>
> I went ahead and pushed a bunch of your patches to the k-u-t master branc=
h=20
> now. However, there were also some patches which did not apply cleanly to=
=20
> master anymore, so please rebase the remaining patches and then send them=
 again.

Hey Thomas,

Yeah the sc patches were based on top of the big series, so some
collisions expected. I'll look at rebasing.

Thanks,
Nick
