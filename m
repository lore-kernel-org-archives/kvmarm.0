Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FE53D666A
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782226876; cv=none; b=i4xgBK/y2JWkTIPKrgdmucK9Dw6LKrirMofOUBMAgIsykJ/Uu/W5YWuexNQMXk3pgQQ+LDDDrcDwfOXcUW3NViJUKiJNHql0P57Gv38G1FeUyFQCZ1W05pQHbbfAxruHcMHLH5oGnlXG2EwWR/qS8phozTrdYzUpSsrjcyrFrjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782226876; c=relaxed/simple;
	bh=e2FnWsMy6T6/89TNXSXemivgXsEc2hl7D7EPV+933es=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=R6lHlsRj0VQBmTyb2yAug78kYyvs9vt30EWYef9pWWWz32X03vBJA2CpufXpZZ+XrIC6958ZyEkZi7nDE+CTgPZkq0jaK0eQp5u/wc1Ijo0WtH4ZhvCkrzSLnyylUhehWYMKDz69ClyhiLylkNCU0iN0/UM8a6pn6coo9ZIGfNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=Wb20dxWo; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="Wb20dxWo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782226866;
	bh=FMcvrNMeiunarYDVwOG320BrY694FQ1Ht0HcOfuTAsY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Wb20dxWoONi9pPs2QuazEXjNsezuZUxJfr6Bt/lJx6L2U5wYsR5Qp+2v8p4iKpKWB
	 s6YNPlyU+s4GKPlZyLagwVVt3BtXN5LIcebqRuRBmgkhCN7gWjjlD69Hbur4uWxdVx
	 7pqTFjRLwTMvMunQ9fse9F940xVyvwizQm7889lA=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4gl7YZ52K9z10tQ;
	Tue, 23 Jun 2026 15:01:06 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4gl7YZ1VJCz10tD;
	Tue, 23 Jun 2026 15:01:06 +0000 (UTC)
Date: Tue, 23 Jun 2026 16:01:05 +0100
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
CC: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
In-Reply-To: <178222278590.523236.18181071715501850418.b4-ty@kernel.org>
References: <20260621213155.6019-1-include@grrlz.net> <178222278590.523236.18181071715501850418.b4-ty@kernel.org>
Message-ID: <CE64C9AC-32D5-495E-B713-552921468FB9@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On June 23, 2026 2:53:11 PM GMT+01:00, Marc Zyngier <maz@kernel.org> wrote:
>On Sun, 21 Jun 2026 21:31:55 +0000, Bradley Morgan wrote:
>> Protected guest faults charge long term pins to the VM's mm. Teardown
>> can run later from file release, where current->mm may be unrelated.
>> 
>> Drop the charge from kvm->mm instead.
>> 
>> 
>
>Applied to fixes, thanks!
>
>[1/1] KVM: arm64: account pKVM reclaim against the VM mm
>      commit: d098bb75d14fde2f12155f1a95ec0168160867ce
>
>Cheers,
>
>	M.
>


Hey, which tree did you apply it to?


Thanks!
