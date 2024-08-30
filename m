Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5241AF4F8
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026238; cv=none; b=qtMrIKxuQcga9GgDG38vZiSrqw2NJjO/ia8xc7pY3zMXPPw2rqH3XzZ7zzh5HrkzNr7tKqsG4i18yoUbwLo4iFBzWtl9TCUcjyHdwqxiWCiMN6Vukf7eCUkjbFkESctIyfgmnaEXjVCOUaKgjXHAjnpQN6ZTYuq+CC2M/vckJsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026238; c=relaxed/simple;
	bh=NUlKGhIyCsQGFAYIgqP91JPxVHe0dLUWSGpMcalpvoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aJC1Svr0cbgBMm5JEJEXydmcO4MnUFBtGnC0jWcIlH6IwbKhTYd3ysw6BuWQoh9D3hnSSEglrSbiO6dH/gu/8DdLQhLgEQHtfWYhf0h2OrZSvg64h/hKks0Vy2rX3J1PoLMyAb1V1Q68Q+6gXWiVmlbXJ2l1IGuTI77QAefij1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMh+sm6Q; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMh+sm6Q"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2039405b567so15981525ad.3
        for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 06:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725026236; x=1725631036; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=58CvTL6COAyoekWQp05GB8r3Lb0Xc+vxoLW2O7LrDWY=;
        b=vMh+sm6QtmfVIxNYxov/sRAQaoUS1IreRIZIKzAzP14Mv9a3WTi02trVqFJph4ZnH+
         DqmJmwd7d8dLadHY7BcmuSHlYrhTmKUU7wdldxXPJy300plDwkBRmhNkt+kIeTi7muUX
         wWI0Omuf60BEhHOuHKaOkEQMLy775FtPKIpF5KED9hJ5lD9D/rqZ5uNejr+dIi8IANyE
         wv0zjbq80Z1oJ3wuu/HxSxOy2pblIRSh7+OInmNE8ZirI/sfu7pVmUqFhTmoGga99gmk
         Czj7qJIs2VPHHEj+JnwbLqnQI5RW/5IOcKYhKv04sxI+7xXxCMlc0SOO8ygwU/zS2aFz
         47UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725026236; x=1725631036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=58CvTL6COAyoekWQp05GB8r3Lb0Xc+vxoLW2O7LrDWY=;
        b=LVwLiQz7JDdK2Qtv016qoAnwkqxWxFJ8Kp/WbgKpUhwwGb/wZvpZp55VrBY838O1pH
         IJ3QO05gw46oh149GGpvtxwm19ZU2Cz8XrS6neT3iWkmz7P2081515CEOeOEI//jQJKs
         3Y+61eTX0tOPAjDuz70YDppaKc/yQ6jub9uRqE0N/QlIG361wmNFRr0FXqvpa8hIFp36
         U2/JZhsqga8sCU4jqgtJjRyX1+nH+3DkvvF7MazvZwNDOSmqnIM06/ItWsm12EGRMKmg
         e6J7YpfAjQ7PX6KB/NeHiJGp0hSr0+5H9+CzzdT3m44+y4Y/SomR3Z/7C/aQTi0K3WHx
         tSWA==
X-Forwarded-Encrypted: i=1; AJvYcCX6BSOA5fxvvmOq9F0H/nQ8/LWxtzNu4loNfADFeOne7rlR6d2s1X/6V0QVeSFAgNGC4oo60G8=@lists.linux.dev
X-Gm-Message-State: AOJu0YylhCAcH/ljFXhWjxmtPkX/zgX1GLN+Z7WvF9NQvACz2ifT0uHZ
	xvO2dsfQeghG8q09eHCS3mfmDFmFKTEofQ5j/l7N90M+7JzgOSXORjtYKB81b9/VaOvn82yBf8H
	XDQ==
X-Google-Smtp-Source: AGHT+IExGR2RCNKu/4M4z4IiNUcplAydPr67v3iYUD8ZfSJDuu52D1tVexWQwhZuKUP8XxVYEYjpc6MqNEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f90b:b0:1fd:9d0c:999e with SMTP id
 d9443c01a7336-2052857ddfamr344725ad.9.1725026235523; Fri, 30 Aug 2024
 06:57:15 -0700 (PDT)
Date: Fri, 30 Aug 2024 06:57:14 -0700
In-Reply-To: <1f037b5604deb5f83f05e709b2edf3063372518f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com> <20240830043600.127750-2-seanjc@google.com>
 <1f037b5604deb5f83f05e709b2edf3063372518f.camel@intel.com>
Message-ID: <ZtHPusyTNkQ_a1Y-@google.com>
Subject: Re: [PATCH v4 01/10] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Chao Gao <chao.gao@intel.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 30, 2024, Kai Huang wrote:
> 
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > Acked-by: Kai Huang <kai.huang@intel.com>
> > 
> 
> Hmm I must have done a lot for me to receive two credits (and for most patches
> in this series) :-)
> 
> I think one Reviewed-by tag is good enough :-)

Heh, indeed.  b4 has made me very lazy; I just `b4 am` the patches and let b4
grab all the trailers.  I'm guessing something went awry in that flow (or maybe
you acked a previous version or something?)

Anyways, one of Paolo or I can clean this up when applying, assuming we remember
to do so...
