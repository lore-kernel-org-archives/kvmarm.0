Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1813D244
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725294618; cv=none; b=di/TlDGJN751RJPE4WSaapLjZbwOF4F+20MxgaTBX3BWFUV/EqfljxeWay2xQ1JsY5bRr34zaeKZG00Nrh+jDfM+LMJ1sRbM5POjP8d0fkVy3JtkDFmuhe2iRazRxIMkD2n0EKoPNhdKw8WZFGqLU+VdpR3ccOaiG2A9ud6q6Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725294618; c=relaxed/simple;
	bh=y9rmIZUkhHhDge1AsTeRB/wi3YCOD8AGEoMcFfCtP50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sUekDvpD+ZVS8BAPlUV7T8TPk5061kAyF3G/Q/nnITT2hHAuYU9CuaU+SuKPMa8zKCPB4nI/v4Q3GAQjvRYgr5aIBnVFfQZJCKKjTisKuYPlxI5ImXodJjLjRxP0Vx7CzWnkgpYLaF9KEE1bBDSEzv+2NJ/kDNKbpQshvSOkO5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GJaN8xfY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJaN8xfY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725294615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9rmIZUkhHhDge1AsTeRB/wi3YCOD8AGEoMcFfCtP50=;
	b=GJaN8xfYp+PAn5ky8tGNfF7yCHmrcoHN8vwori4q1a4/KYikMZLkMH2+098C3QSgfYSdgP
	lr8QdwbTgfcxG4ZOvJgNITNRm+gPrVjXMcqzCviTKwbDY2zGfmoT81ClGWshlfd0C7r/5v
	FMGNhgvicm+v8zG9jrR3NlfwDdJs4WU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-0rUkoCZzNUy59LMGiue2ZA-1; Mon, 02 Sep 2024 12:30:14 -0400
X-MC-Unique: 0rUkoCZzNUy59LMGiue2ZA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71447abc57fso4268461b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Sep 2024 09:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725294614; x=1725899414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9rmIZUkhHhDge1AsTeRB/wi3YCOD8AGEoMcFfCtP50=;
        b=MynB2MnpXHydLXCmXVALynNdK/+scLnNMlOkS0x72dab33gI+qLbgeCeMWnXNBkugX
         yYKgE1Wj/xJrm/KJ4Rzb+96CTGejXv3l6zHL9rd21MtUKhFM8H/9zqGLiACdC+ggju67
         /UfcjkWwCJzNZHmTTA4UlI3EKE26Eqb+yLhm+LIlLQMcZBTbyf8CrgZeHHYEPJNrw9Gy
         U18eZWuAunnpRX4dAZdaC+9sGenjGJvzzxHm27GTIS8kq+bTO1y4l/D/rogme24xQMQE
         nLweLRpAU4Mbbot7akOpASkPny/L8YOfwXrgpBvG4FRqU7N9etu8oIjDxQIs3j2E0ifZ
         zUDg==
X-Forwarded-Encrypted: i=1; AJvYcCXASvwjySYBBoymFC2181t7abIO1b5nGjD1OAx/vUxDJhAsTeb47LquLrl9kHEfnB7qSY/OORk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYQ3e7yQhutkWC7s82JwyIVlqtobpuoXK3g0tKXAXfJJBq4WTe
	/BCR0gxJIruPmPNUo3Awr905Soscv36XrA7Q6g3qernT7p8nVz3OSJPK5vPLiFH9zMXo1/vDlgS
	Mr/OMCXezm9sdudeJ9rohb4/PEwoO0Kh33NA8uK1cxWg5RNCSFGooAE+QBGpckh+VbitcpnDUQX
	9ACk/tu7uLexLOALG2lFsd7knEUY/P
X-Received: by 2002:a05:6a21:394a:b0:1cc:e4d0:84e9 with SMTP id adf61e73a8af0-1cece50235dmr8036823637.17.1725294612295;
        Mon, 02 Sep 2024 09:30:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoBISUpaETKmXWjYLMX9OvXWf6NhGf8camXMY3dXDdiY//ktjWVoWIvLx/zwhZ290M/DMXm/zvrJoNfltI2Mk=
X-Received: by 2002:a05:6a21:394a:b0:1cc:e4d0:84e9 with SMTP id
 adf61e73a8af0-1cece50235dmr8036803637.17.1725294611883; Mon, 02 Sep 2024
 09:30:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Zsb4kbq6FAfgg4WA@linux.dev> <ZshONupF3nIhAlRf@arm.com>
 <CABgObfZ=P-Qc20SD=duFtDbCefWGO9YoEcA=S0DaTo59x58iYg@mail.gmail.com> <20240902150725.GA11571@willie-the-truck>
In-Reply-To: <20240902150725.GA11571@willie-the-truck>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 2 Sep 2024 18:29:58 +0200
Message-ID: <CABgObfa-hR5Xx5ORXAhTmvxChK=77WpWhD5erWK=cz1MTZoJsw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.11, round #2
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 5:07=E2=80=AFPM Will Deacon <will@kernel.org> wrote:
> I think this was all pulled by Linus over a week ago:
>
> https://lore.kernel.org/all/ZsjE6BXzDznbg6R-@arm.com/

Yeah, that's what happens if you "git rebase v6.11-rc6" on the wrong machin=
e.

Paolo

