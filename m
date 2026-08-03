Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7CE3438A2;
	Mon,  3 Aug 2026 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769596; cv=none; b=fpZ67h95Ecam2IhuMn6nvfwG2r2zv8For0j0v7JNQaPwGoiq91v0LyBmXsxUpGqYx4Kduh0LkD9t+ooZ5fpTZuZAIzu/IVVEyfkb5BTA536a2VGSzRuV3DGRdrCLoYFFD/E2Zf0pI01sugQCMSzlsu4VGDYxPIb5UfyVaJBYzVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769596; c=relaxed/simple;
	bh=AKHk4mlXMEmidkB6mplFPKFhKVxhdwJ+1dQAEJAtyyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eIaxN3ffG/JLDFgSQym8O6RUWaV5fgJsS+EdN6oWF8ODAxoi2sr8VtQkFZz4LdqRx5V0YHlDes9yY81DlFZAP2n/qVgtNvf6xR7Pp7rNkvBSDtNDldhohpcjhvB6ClUUmoIzlAcDYqRK736ijcCkZXSeLZJPjhFzbpVSdhfaNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BNQDBx3n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BNQDBx3n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A164143D;
	Mon,  3 Aug 2026 08:06:30 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E09E3F66F;
	Mon,  3 Aug 2026 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785769594; bh=AKHk4mlXMEmidkB6mplFPKFhKVxhdwJ+1dQAEJAtyyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BNQDBx3nISccFEihc91rkcvYVRSDUBe855HEni/Md3KgHmB0IcddGK1GnAbb/YQzG
	 LC+n0k7cgO8GvGUmlv5JUbQ+ygUMmMUFvBKVlL7+rNiWOlx3HOAy/qxy9y7e2IryaV
	 3E4AOCSx5ZHoMYwI6fYIZ99a5Rc2CBlcf1PbOxS4=
Message-ID: <57225daf-4319-406a-8328-e32835e8a980@arm.com>
Date: Mon, 3 Aug 2026 16:06:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <86y0enb64s.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86y0enb64s.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/08/2026 16:01, Marc Zyngier wrote:
> On Mon, 03 Aug 2026 14:43:16 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> This series is based on the guest_memfd in-place conversion v9 tree[1],
>> which is itself based on kvm-x86/next. It is also available as a git
>> repository:
> 
> Well done. Series on top of another random series, based on a random
> tree. Unusable. Have you realised there are reasons why we (KVM/arm64)
> ask people to base their series on a *released* tag from Linus' tree?
> This means that Sashiko cannot, once again, provide any feedback on
> this series, as it fails to apply.
> 
> Just to avoid any ambiguity: Sashiko reviews, as annoying as they are,
> are not optional. They are very much mandatory, and I wish I could
> turn back the clocks to run it on my own code...
> 
> Running it on your own is not enough, because *I* want to see what the
> tool finds. Not to mention that non-Gemini runs of sashiko are much
> less interesting (unsurprisingly).

Sorry, but I'm not sure what you expect me to do - clearly I want to
base my changes on top of the guest_memfd series which is being worked
on and not just ignore that work. So I've based my changes on top of the
tree that Ackerley published.

I'm certainly not trying to avoid the Sashiko reviews - it's a rather
unfortunate limitation of the public tool that it doesn't seem to be
able to deal with these dependencies. Or is there some magic that I can
do to fix this?

Thanks,
Steve

