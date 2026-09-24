Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F033F8EB9
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790230173; cv=none; b=ka7dC7+iiCOXjt8QqHkzXer5Md+TDdvc3YqmegW9HpyEvueQuRB6BwGed463s9Zev7JEpmXM/l8JVdR29ZTeA6Rygxepqmi1BVS9EDZ7sCbZYQHJ/3w6xUTUGqXCXxIc/e0MIhwunoOfbMQfgzHVoscwFNfPg/X9hEk3XPKwMhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790230173; c=relaxed/simple;
	bh=EAQiwSLU8WvEPiMz51OeeUlVyfvtoZuDVj/Ws6zFfEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwJTYEZaBU+zCfFgf2SKdN4MNFr7j1a/qrgU+mSszH69pHrJPwypUqCu12IF0rfAT+cCUT5wekzz7Pd4VCTQSVZK3OvFwQPa4SKhrVGxIcrWOhOwvcRuz2JcOZBzpSUEGcEKCebManBA2qMy2dScrZBr7z+buMzaL7amT152Zuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RwyPMycL; arc=none smtp.client-ip=91.218.175.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RwyPMycL"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EAQiwSLU8WvEPiMz51OeeUlVyfvtoZuDVj/Ws6zFfEs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790230169; v=1; x=1790834969;
 b=RwyPMycLLo6EP37iZ3yfom5Kax1mdAGhr9R5v4HiSATH48uds4NhWfZPaOBd0Sof+Vu2Nm5N
 SG4IUzesHk0g+OOShTgFBQ3NW0P4RLQtH6QAgtxNIVvcXkAuDWGcF7rBjIqAz63tRXVp2GiLdL3
 S6qNW/GB6+8j/RpjKBsfhKL8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4dffda36ec3ddfe2;
	Thu, 24 Sep 2026 06:09:29 +0000
X-Mizu-Trace-ID: 4dffda36ec3ddfe2
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so3519e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 23:09:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwOQRylKHG91pBtLju3yTT82bPbZSlLu+7D4V7vhK3nazO6GUhVHt36xiraoy46Uovgr/DeulA=@lists.linux.dev
X-Gm-Message-State: AFuF++n/vVwrri6tvt66/g4/ukuZsavBGVNOElQCCbpp1hnInUN2Ku/F
	huNYkiv+Vdt+XemDRMYXf8ispuWjJTc8B4ze4XOvUxDpg/5RgCJF8kIL33wBJ9D96JLuYSMpNC/
	IL0YvcWdx6CXPrfe/RjI04bv2tn/Z4bmEA5ZAZtkE
X-Received: by 2002:a05:6512:ba4:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b8de3bb43emr120128e87.1.1790230168511; Wed, 23 Sep 2026
 23:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-13-d4b0b4dfa8c3@kernel.org>
In-Reply-To: <20260923-kvm-arm-prefault-v4-13-d4b0b4dfa8c3@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 24 Sep 2026 07:08:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyPyy-Z=HAMOz6pUHrz_X4O+Lx3cQ6Ay_Wt+tnc1WDU_w@mail.gmail.com>
X-Gm-Features: AclHuK8PM-gKMDq-u5QWjDRmdsBji-o2uwHNqiDgg3TNGtYz82rPBW9_kKwo1Hg
Message-ID: <CA+EHjTyPyy-Z=HAMOz6pUHrz_X4O+Lx3cQ6Ay_Wt+tnc1WDU_w@mail.gmail.com>
Subject: Re: [PATCH v4 13/14] KVM: selftests: Add option for different backing
 in pre-fault tests
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
	Jack Thomson <jackabt.amazon@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Wed, 23 Sep 2026 16:15:56 +0100, "Lorenzo Stoakes (ARM)"
<ljs@kernel.org> wrote:
[...]
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
[...]
> @@ -189,24 +195,28 @@ static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
[...]
>          test_config.test_size = align_up(TEST_BASE_SIZE + test_config.page_size,
> -                                         host_page_size);
> +                                         mem_page_size);
>          test_config.test_num_pages = vm_calc_num_guest_pages(vm->mode, test_config.test_size);

With -s anonymous_hugetlb_1gb, test_size becomes 1G and setup aborts
on 4K guest modes, as memslot 0 has no room for the page tables that
map it:

     No guest physical page available, min_gpa: 0x180000 page_size:
0x1000 memslot: 0

As a followup, could you compute test_num_pages before creating the VM
and pass it as extra_mem_pages, as arm64/sea_to_user.c does?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
