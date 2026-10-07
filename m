Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BE33B38A1
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 11:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370883; cv=none; b=DKVCJrvlNnXbA8Kufe+ZSaHmR6tTPpfEtijUyc8NctsF5t5XH6mKPQ+6tHpu9mMzNBl2pl4/zzsI4KEW8vS7rt36eGoP42MAvQ+LNUo8KD60dKfyqvEzMnj8crgGy86XE+eKFzP++etKqdGyKiGEAVGzMDzxe/9juGA5XiHGYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370883; c=relaxed/simple;
	bh=7AAmUdrhI1yAcj5z7olkLM57zlwGodlaq9p9uBBFRNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dl6r9gmRekdazuJZ8Pm9A9rYUlSj/eimLj5JwRfV+qBK3OI2gVmX2jl+rpo5x/X75ng2Ew/iaeH5tqVSp2XZkDCqMIQqFLCsTvkXKzdAj2ecWQWXkCi1B4+08agfqgZdfvlSOFe3kFU/se6+q/wfSyvx44rpbrsyFBE2vGSdlAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kMf86bdt; arc=none smtp.client-ip=91.218.175.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kMf86bdt"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=7AAmUdrhI1yAcj5z7olkLM57zlwGodlaq9p9uBBFRNA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791370849; v=1; x=1791975649;
 b=kMf86bdt/fxSTphP8srM0RJriilDHQmZ/3D2/MUVszuW0/QTJCBA57GutYzvOmj21c4cPnco
 Ev/GjONBWJej7r0ZCpHG9nSUrc67Yb4H15UTvcdu9tZ8PCdK0yxIY8a1elSQIEHtBsoMOzjkFzO
 fNxBSgivpWSLaOuljhY2wSWk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 016527d3bb915781;
	Wed, 07 Oct 2026 11:00:49 +0000
X-Mizu-Trace-ID: 016527d3bb915781
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so5592e87.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 04:00:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByHm2o+xZdSIUstQj2jmsR6Grwj5ZomnsaQn/UsgWxkasJP4cSAqCGEojj4l1famWlv1npYK2E=@lists.linux.dev
X-Gm-Message-State: AFq9FYJdJnTewCRDj1eppSLW6JlDyZvxawOw1fGfrHOysJ39WvQ+W8d+
	K7+DeCS9IMyUK+CRjcoJ8OyytjuGqlJqX7K+sS2Siy4wI/NlIL8ST/uIteACL+9G8XmwIIrFCEH
	ghLxKsTC2gNFSyyGHQphIVBs3XKo8ft1oa6cGzUs7
X-Received: by 2002:a05:6512:10c4:b0:5bb:7b34:8e00 with SMTP id
 2adb3069b0e04-5bcca834338mr303502e87.6.1791370843101; Wed, 07 Oct 2026
 04:00:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-4-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-4-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 13:00:06 +0200
X-Gmail-Original-Message-ID: <CA+EHjTwdoj8k8-To5ywwDO18Ek-sET5OHbKuawatTNvMc6gyGQ@mail.gmail.com>
X-Gm-Features: AclHuK9kFsM0C-8314xeyKxj7wNCXh1xIF58U3OrNPCRgmPj5uaBmkaoPd_Q9sw
Message-ID: <CA+EHjTwdoj8k8-To5ywwDO18Ek-sET5OHbKuawatTNvMc6gyGQ@mail.gmail.com>
Subject: Re: [PATCH v23 03/14] KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Oct 2026 at 09:36, Suzuki K Poulose <suzuki.poulose@arm.com> wrot=
e:
>
> Fix a potential build error (like below, when asm/kvm_emulate.h gets
> included after the kvm/arm_psci.h) by including the missing header file
> in kvm/arm_psci.h:
>
> ./include/kvm/arm_psci.h: In function =E2=80=98kvm_psci_version=E2=80=99:
> ./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
>    =E2=80=98vcpu_has_feature=E2=80=99; did you mean =E2=80=98cpu_have_fea=
ture=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
>                  |             ^~~~~~~~~~~~~~~~
>                                |             cpu_have_feature
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

nit: If you respin, could you update the commit message?
vcpu_has_feature() is in asm/kvm_host.h, which arm_psci.h already gets
through linux/kvm_host.h, so this error can't happen. What arm_psci.h
uses from asm/kvm_emulate.h is vcpu_get_reg() and vcpu_set_reg(), in
kvm_psci_narrow_to_32bit(). (Sashiko, confirmed)

Cheers,
/fuad


/fuad
