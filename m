Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3FF49BD7B
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161694; cv=none; b=AzLnK18Nj4IvEt6Tk3SJDRG190+oYxetO6QiYTIv4lL04YqqxUyuqdip6Y5wZEYKABC38P6I3htK5spV2wub9wFdkyicBz66UB9yeC/VdCkMZPPLolnVOAu9BvqZcCVqaTXJVPxMohKXVOuzXsEoN5uIu8ED7vro1ZBj1N+VktQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161694; c=relaxed/simple;
	bh=IOAKMmCBlI6Y5ADecDu+BXYPFKPVLUehlx/wlSNc7CU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LBCBV/2DaZ3p6ZgUNtKPnehdZ0sK1lo37gtf5CBkk4Am19JT2tMMXtHphkklP5cKcvWbK/Ss2DQZpBZzUcQ74cghsKou9ZiHQzWmRiAqUH5jCdtkOi3qYko46WgBAQpubUdNlFm/zNWRbkfofJQRJjtE/qOxnK9+IigGLSYxNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TkR8QLo8; arc=none smtp.client-ip=91.218.175.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TkR8QLo8"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IOAKMmCBlI6Y5ADecDu+BXYPFKPVLUehlx/wlSNc7CU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790161691; v=1; x=1790766491;
 b=TkR8QLo8qytpbREmjM/cCb6CluIj5CurOsgyPUC4cLfTOMwe0BeN6qVNPCxZI/m/HXdMg2t5
 tsxt4ZSPLMwnBmBkN352DbnUnSAJqJgDhW4TWQVmHPjqimlVikA6pzu6mUZgZT5th1DQXjA0KI+
 B5sA6faZNHhZFM9Fim38qqxk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d78635945401060b;
	Wed, 23 Sep 2026 11:08:10 +0000
X-Mizu-Trace-ID: d78635945401060b
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b8c42da963so5345e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 04:08:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxwYdvsKNg0VTdFHKrmybl1AJc+VENVEp5SLIR9wr8bCx2rQR4Rv55zcwwjsqsy1D3OfGnGwYM=@lists.linux.dev
X-Gm-Message-State: AFuF++k8xD2bFF7I4xCiA3k6ffaLKzruUsnec396B1G+cGOv0aKflAf7
	sWuTANwkFDp2/WNxEkYjr4HbKe7Mh5hRhq9bS7RhYTceMxaep1Gzbyd6UQwjcaeQKy2CkYa78rH
	ZGPFyqomYzaGLNAz9VjN7lRe1THZaiRwUOGlY3547
X-Received: by 2002:a05:6512:648a:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b8d91673a2mr102638e87.15.1790161689001; Wed, 23 Sep 2026
 04:08:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org> <20260922-kvm-arm-prefault-v3-9-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-9-787bd3bc7e3f@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 12:07:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzY6KFekqaUX4RLRyFmSkFhOeWDZE4LjBF6owdLM8oHhw@mail.gmail.com>
X-Gm-Features: AcwNN1USJQu0cBxPqG4Fa3XJmPPBE73PzJ6UtD9si6PNBcHUySSR3TM9mD5mIUk
Message-ID: <CA+EHjTzY6KFekqaUX4RLRyFmSkFhOeWDZE4LjBF6owdLM8oHhw@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Sept 2026 at 15:19, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> From: Jack Thomson <jackabt@amazon.com>
>
> Allow callers of kvm_pgtable_get_leaf() to specify the page-table walk
> flags, in preparation for performing walks under the MMU read lock.
>
> Reading a stage-2 leaf while only holding the read lock requires
> KVM_PGTABLE_WALK_SHARED: parallel faults (which also only hold the read
> lock) can unlink table pages and free them via RCU, so the walker must
> be inside an RCU read-side critical section, which the shared walk flag
> provides via kvm_pgtable_walk_begin().
>
> All existing callers either hold the write lock, walk with interrupts
> disabled, or run at hyp where shared walks are rejected; they keep the
> current behaviour by passing no flags.
>
> No functional change intended.
>
> Signed-off-by: Jack Thomson <jackabt@amazon.com>
> [ljs: fixup new kvm_pgtable_get_leaf() invocation]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
