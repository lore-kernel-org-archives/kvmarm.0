Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445F6223C67
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 11:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734608138; cv=none; b=f51WTDEDvprEYCihWM3oeV/RD61sRviJyFnXSwlOfZJ2jj55yJCptTiiMT1++4odfoO8G4/PA9rssE00i9ZDabHc5qhxd4HoFF5/rdbKIbRKtmDiPW2nW9fcIvxLpooDvRhmOYUXOcWo5+4J+hB0+2sJwT2jU8PtHk8tqhGiaUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734608138; c=relaxed/simple;
	bh=h+tW40KPLTVaK3ARl1ZR83pVvbmYhQqTxWDIo9cbeak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJkECa2Xg0IJt8yj7IsPr9i8tOURiLjwoFFgO/XuAtT5E1OBM1ugC03dqD+Z9CxHAX6yIS4cVT1FZHMp0Wruot4efM013Wi+4xIQyypk/JP7AlfBgM0qJX2ZY+UxCmJrv+aD8VZxL9CLctFyDh9alHXRFtKxFqWG7l9VxjLya70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fFU+6lpl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFU+6lpl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734608134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yq+VKCJRuzaPj/tEAEpk5ad2XnMB+1nVIjSVaI1/maE=;
	b=fFU+6lpleO1BQx+GMA/r8dsE8cgX5ONgl3pQo0YYPwxlWVO27/9ZTbR4Ma/2plLEDy8ZWl
	bQAa7OmYd5r82v6RnHxPCJK10tk3IUdIst7dg/9/h/4rqfNYHDoxQ048sp0Ft8/UP9bYmD
	bTojnNZP2lUq2F1j4JG0NrNGHoYbkRo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-6TGaY4NcOJSmusE8GbInrg-1; Thu,
 19 Dec 2024 06:35:32 -0500
X-MC-Unique: 6TGaY4NcOJSmusE8GbInrg-1
X-Mimecast-MFC-AGG-ID: 6TGaY4NcOJSmusE8GbInrg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3678719560B3;
	Thu, 19 Dec 2024 11:35:29 +0000 (UTC)
Received: from gezellig (unknown [10.39.193.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED11630044C1;
	Thu, 19 Dec 2024 11:35:20 +0000 (UTC)
Date: Thu, 19 Dec 2024 12:35:16 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
Message-ID: <Z2QE9AqZnpGM5sWD@gezellig>
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <Z1qoa8yXscTSAJ9e@redhat.com>
 <8734it1bv6.fsf@redhat.com>
 <1fea79e4-7a31-4592-8495-7b18cd82d02b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fea79e4-7a31-4592-8495-7b18cd82d02b@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Dec 12, 2024 at 11:04:30AM +0100, Eric Auger wrote:

Hi Eric,

> On 12/12/24 10:36, Cornelia Huck wrote:
> > On Thu, Dec 12 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:

[...]

> >> Consider you mgmt app wants to set a CPU model that's common across
> >> heterogeneous hardware. They don't neccessarily want/need to be
> >> able to live migrate between heterogeneous CPUs, but for simplicity
> >> of configuration desire to set a single named CPU across all guests,
> >> irrespective of what host hey are launched on. The ARM spec baseline
> >> named models would give you that config simplicity.
> > If we use architecture extensions (i.e. Armv8.x/9.x) as baseline, I'm
> > seeing some drawbacks:
> > - a lot of work before we can address some specific use cases
> > - old models can get new optional features
> > - a specific cpu might have a huge set of optional features on top of
> >   the baseline model
> >
> > Using a reference core such as Neoverse-V2 probably makes more sense
> > (easier to get started, less feature diff?) It would still make a good
> > starting point for a simple config.
> >
> Actually from a dev point of view I am not sure it changes much to have
> either ARM spec rev baseline or CPU ref core named model.
> 
> One remark is that if you look at
> https://developer.arm.com/documentation/109697/2024_09?lang=en
> you will see there are quite a lot of spec revisions and quite a few of
> them are actually meaningful in the light of currently avaiable and
> relevant HW we want to address. What I would like to avoid is to be
> obliged to look at all of them in a generic manner while we just want to
> address few cpu ref models.
> 
> Also starting from the ARM spec rev baseline the end-user may need to
> add more feature opt-ins to be close to a specific cpu model. So I
> foresee extra complexity for the end-user.

(Assuming I'm parsing your last para right; correct me if not.)

Isn't a user wanting to add extra CPU flags (on top of a baseline) a
"normal behaviour" and not "extra complexity"?  Besides coming close to
a specific CPU model, there's the additional important use-case of CPU
flags that provide security mitigation.

Consider this:

Say, there's a serious security issue in a released ARM CPU.  As part of
the fix, two new CPU flags need to be exposed to the guest OS, call them
"secflag1" and "secflag2".  Here, the user is configuring a baseline
model + two extra CPU flags, not to get close to some other CPU model
but to mitigate itself against a serious security flaw.

An example that comes to mind is the infamous "speculative store bypass"
(SSB) vulnerability and how QEMU addressed it[1][2] in x86.  I'm sure,
as you know, it also affects ARM[3].


[1] https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04796.html
    — i386: define the 'ssbd' CPUID feature bit (CVE-2018-3639)

[2] https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg04797.html
    — i386: Define the Virt SSBD MSR and handling of it (CVE-2018-3639)

[3] https://developer.arm.com/documentation/ddi0601/2024-06/AArch64-Registers/SSBS--Speculative-Store-Bypass-Safe

-- 
/kashyap

