Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C412F3C3D
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 22:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765580346; cv=none; b=Dk1QZ12XBjm2/IDc/9QBfwMe7ED3zfH26jPgr2GW/y0weTK8iATHajL+RKLN/hhSZVZksYcmO2PqWo1nILF9c4l6wYirg4iXRvOMIN7eBUSHDtQ8vrcq6GlKQCqDGNVuDMSb6CxyIUk7aE2W++DPHyBu4sb04lxMjai56w84hFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765580346; c=relaxed/simple;
	bh=7bslInIBLJIoLn/9TutWUpr69eWhQhXaLvHEGWAesY0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KBGIxPM7pd0jrnp2FOgfqfYC0f97laLgaV6Gpx3Sjb87oSM8fMZFcyimaTzvHJtCbHVUdPZA4HAuBI0MUjEWdj+4ZZKgSA58dd6OCAScgZVrUCYoh1fdUzL1vo4zuZ2lCyc/7JXNcEuYzIjTZfw7DLELHRJ9+Yc2tqrBP0ZeRYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pFFj53E0; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pFFj53E0"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c6d3685fadso1612550a34.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 14:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765580343; x=1766185143; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tBFcNzGChK01MBl7aRFxeqVQzmaQvoTyGJMrwZXP/1Q=;
        b=pFFj53E0i1u0yxHWi83X/zqLsM4tVGW1otGJtkKeEs/6UWAG0qK0BiB9k9xUkomyom
         oUVY2wwbld2QXLe7PNgFL3F3n52YIUe2/8ajtQzLoejTrkulZYHy3iIRO5rRPa3iLE4s
         MZDGzW817B+DPKuDOJoTMNr9yw0zWT7R+9bh9oHjPIzOLk3g4a+PYwr5ULKP8smdqRs+
         RVpqWgag5PZcSUdYb+aVHx6Zge6lmhaZKXo7XIAwxKgdk+P7Az/gWcrK7tceGtgh2j7a
         wzrrWHIuzFtG+q++ZCJ5R3OXdrNhT2uC0TCM+llpmT8Iq4/pqxKoFUhe091nEv7Tzw9I
         a/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765580343; x=1766185143;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBFcNzGChK01MBl7aRFxeqVQzmaQvoTyGJMrwZXP/1Q=;
        b=XDuJQl0Dv0XtI9ysdQ+4dmVFwAkmhFh6gnb/NXohglLeCrsFfTnOzjvKUyQ5UHMGY/
         41CdQCbOYJNVMabGo8vwLkcfI8UNR6QQV6qaydvP4eVHEnlDjt0jYmrI4X9hGwu1wGqi
         9oYUCQPJgNzpiXidzsvZHhGWWq3Tj+Q3pJOe1b/S4icVybr6WA3vni6Ji0ijHI1IV8F7
         CZyYv5VzS3ISUNkbbYhaFNQ91K1i7rKuQXvgUf7HIB9nAC/CLBrUDNhM3mBJXCpgfjL0
         qKhBtcAz9esArcre/bZlt45CQqeNq9cWNeiRvPmLndPwE5ajMbYuXByPrRGVrd5ppKfz
         mKWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7QfrfhO+mVWK3P3xrYPiIB+jilOSCofI6s/g4D03Uy4eRlmg33YIHDRvvHOexneuLvbBUPR4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNWKrYJg4QPogNp/j9CcWKdzAsDQaIl0+oDvO3puAvhNuWClFI
	2/9TutxtsRJ2i/LiEWwI7EAXn0tnc5Lvvisj2mh7Z/P36N7TpEL9OT2kAKJZ7VLHnsjnC9F9oYo
	GBbn+9eaGeMjTXitP3C7K2BFMNg==
X-Google-Smtp-Source: AGHT+IErW9ttpylPAKTVb6sUEZwG4YGY35EKiSdiqsCWGntNWnLEEqDhx+071F1DfXt8IYeJCob+cCIIDVfcvHekjQ==
X-Received: from ilbbc25.prod.google.com ([2002:a05:6e02:99:b0:434:972f:bf92])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1886:b0:65b:35a2:7a8b with SMTP id 006d021491bc7-65b4523911emr1339446eaf.82.1765580342788;
 Fri, 12 Dec 2025 14:59:02 -0800 (PST)
Date: Fri, 12 Dec 2025 22:59:01 +0000
In-Reply-To: <aTipeb2fAmUtSzzX@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 14:58:01 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt5xab2toq.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 22/24] KVM: arm64: Add KVM_CAP to partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> On Tue, Dec 09, 2025 at 08:51:19PM +0000, Colton Lewis wrote:
>> +
>> +7.245 KVM_CAP_ARM_PARTITION_PMU
>> +-------------------------------------
>> +

> Why can't this be a vCPU attribute similar to the other vPMU controls?
> Making the UAPI consistent will make it easier for userspace to reason
> about it.

I'm confused by the inconsistency of using a vCPU attribute for
something we want to affect the whole VM.

But I'll do a vCPU attribute if you want.

> Better yet, we could make the UAPI such that userspace selects a PMU
> implementation and the partitioned-ness of the PMU at the same time.

Sounds good.

>> @@ -132,6 +134,16 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   		}
>>   		mutex_unlock(&kvm->lock);
>>   		break;
>> +	case KVM_CAP_ARM_PARTITION_PMU:
>> +		if (kvm->created_vcpus) {
>> +			r = -EBUSY;
>> +		} else if (!kvm_pmu_partition_ready()) {
>> +			r = -EPERM;
>> +		} else {
>> +			r = 0;
>> +			kvm_pmu_partition_enable(kvm, cap->args[0]);
>> +		}
>> +		break;
>>   	default:
>>   		break;
>>   	}
>> @@ -388,6 +400,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,  
>> long ext)
>>   	case KVM_CAP_ARM_PMU_V3:
>>   		r = kvm_supports_guest_pmuv3();
>>   		break;
>> +	case KVM_CAP_ARM_PARTITION_PMU:
>> +		r = kvm_pmu_partition_ready();

> "ready" is very confusing in this context, as KVM will never be ready to
> support the feature on a system w/o the prerequisites.

That was a last minute addition. I'll change the name to something
better.

> Thanks,
> Oliver
