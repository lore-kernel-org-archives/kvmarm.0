Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C6E4EE876
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453697; cv=none; b=tAidpkqZ6uesqzT9N3eoGogod1Dmh2A4T2STa21zGOlT2J2BnFeTDf0CKSf2nLtJzNmwRjFsphHVh/BW+6ftBOiVrSsj+zr/JrF8mptrA7B49rhUi0cuxyToDQAGTkAkj2HYS0+TG0G8L3h9kapmFbJb7WbFrj3/z+GgROlQeI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453697; c=relaxed/simple;
	bh=jmE5t/QWYXGduwCXTsexmNTSqycO4dgO83zrtscZu3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GcNNUVh62qDR3VtQzQkoiGZswGptMngTCtgoYdgN+2H3hpcEzlgFNlIAQ0faoPK5IniVfqOhAX2uW34+EXps1wqgAs701WYfzbJGM0hRRFZnev1sp2S+xXXSoxJkBb5SPywS96d+NgaiGnx+sp5Qv4W82gpUoT3z2AUs9PJue2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CCt/bSuD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CCt/bSuD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788453695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=96jSKrblNa/MGHlSRt22d1bqrg1HZKp/dYSrKcWfd2w=;
	b=CCt/bSuD60TgCPDUEZpXzyoqPpiXMarYmCjPx4EsMB3itKnSSSZggPRvotoFC+OJD8SoV7
	Tr0AGH0aEXAbHWyWQqwySvZIw9eTLxp1l8Vt2tJRK6npgXOC16beL4CNVtd4MshaKsC4aQ
	MsXq/0anIWspyXqMDO0xc0PCWHvEHDM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-CijEqLfvOBm8Sa2ZPhQvEQ-1; Thu, 03 Sep 2026 12:41:33 -0400
X-MC-Unique: CijEqLfvOBm8Sa2ZPhQvEQ-1
X-Mimecast-MFC-AGG-ID: CijEqLfvOBm8Sa2ZPhQvEQ_1788453692
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-484362cb000so15997f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788453692; x=1789058492;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=96jSKrblNa/MGHlSRt22d1bqrg1HZKp/dYSrKcWfd2w=;
        b=QKoygIdh/tUy5hlnP0p0mk8Bt96zjYgerN0RjEslwMEGiLk+Abli/B41LM4xtlecEt
         Aky7Z2BaoDMVPVggsfQxfMYA8JjJIPkRLZb/V+lu9nxIXR3sM5WAuU1EEQgU9n8ZVeEN
         ewiCI9wuL4WzjSf21sa9fK8YdZkWC2/83/qicsL0aW5XuXZqoEo12vr5Kba0ItmiHNnt
         S2wqmMeXbtJ32INEaUbnrybWL0L1GCesb/Z1raUqkGXAegV3qX+4koSVD4gSCJwfYubC
         W6Nk4GfavIyNOJ4XoejQKwcwwLX4K7fvIaTZMm1mfWgt3ov3yRY41YMKf3O7tQl2UjYw
         HTKQ==
X-Forwarded-Encrypted: i=1; AKwUvBw+mIZZWnXHtbvmc5ejIWUuuzA/JOG7ggp2i1Kc15tzy+Y4VRrSXprssG3OLYUk8FQCPLSq7Cw=@lists.linux.dev
X-Gm-Message-State: AFuF++nV7s6zkOOHdB4e81xPQ2AVRwPKyKh2nxBkaHoGSa2590lPXRN/
	x3BxPNxOi7hpBEZDu7ubC/DqYVwL40MYkYSEnHDRWKIKnxSgRgebpMcjpoGwDvsFzvpXWfjcVuQ
	gaViEuZLdZahoN4eiMBOJjd2JMVddqW6KQqqO9MTvs7/VeGIj1+ikDOpfW+NyfxjufBET7UJzVX
	xlGOXReTmplp48KMUOEOfQBW8yUCBmO7Tj
X-Gm-Gg: AYBFou0UCkL2vXExfbLylRt/tzbRDER+B+h1vr2TnYMUKy3irFxHJPQhXYrMsPLbqHp
	gR+yWuHQ3eFVKQg/fKFNv9CYffUGQuCQ5rJKdceTH6ulPxhQOcXamQMGwwnJNW5+9PpcFkOsHeo
	D9DmUuVprzZ55pChQLBBipLPelIfybZphnrJEc/DdxyQPYmZrCVvj64PnKceXdk+5zgYFNzYyLl
	WPogwGg4M0TMCFAzGuMulNLHzCwn7VkGRW3t62OvQC1oGjnpfSeCTuge4Lr
X-Received: by 2002:a05:6000:22c2:b0:484:3147:49c9 with SMTP id ffacd0b85a97d-48582315a47mr5571264f8f.2.1788453691964;
        Thu, 03 Sep 2026 09:41:31 -0700 (PDT)
X-Received: by 2002:a05:6000:22c2:b0:484:3147:49c9 with SMTP id
 ffacd0b85a97d-48582315a47mr5571189f8f.2.1788453691502; Thu, 03 Sep 2026
 09:41:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-24-seiden@linux.ibm.com>
 <aphMx5hsoXwIpNjt@google.com> <20260903083857.33034-B-seiden@linux.ibm.com>
 <apmHrnxRLl9BuVhn@google.com> <20260903154317.246414-A-seiden@linux.ibm.com> <apmhX8H-WUc3U4_N@google.com>
In-Reply-To: <apmhX8H-WUc3U4_N@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 3 Sep 2026 18:41:18 +0200
X-Gm-Features: AcwNN1UO9-vCqk6RvEI48oEKpR6Wrb2Fp2swzaiyckPlKKdzDRVW5sMiBpGtdhU
Message-ID: <CABgObfYUYCRtmJkh1Ns4VBbWqk3ggnDu294G9rZ6tva56=F11Q@mail.gmail.com>
Subject: Re: [PATCH v7 23/23] KVM: s390: arm64: Add KVM_S390_ARM64 Kconfig and Makefile
To: Sean Christopherson <seanjc@google.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>, kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Grapentin <gra@linux.ibm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@kernel.org>, Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HEcgxxkea5qlqWIsHewTlhtbTWQWwdxEkMm_ebCKinU_1788453692
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Il gio 3 set 2026, 18:33 Sean Christopherson <seanjc@google.com> ha scritto:
>
> How many people are running distro kernels on s390 hardware?  And how many distros
> actually change the default KVM settings, e.g. to build KVM as a module instead of
> baking it into the kernel?  My guess is "not many" and "almost none", i.e. the
> actual impact on downstream users is likely miniscule.

RHEL and SLES *are* distros, and I am not sure which bank or insurance
company would be running non-distro kernels. :) So I assume you mean
"how many people are running non-distro kernels on s390".

At least RHEL builds KVM as a module for s390x, but it's not a
problem. I agree with you that having the equivalent of INTEL/AMD, if
possible, is a desirable self-check.

Paolo

