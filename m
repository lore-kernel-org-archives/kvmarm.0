Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622358;
	b=UbDzQiiaS5foiKZZyuWv7QVnDudumyYJQWukxCZaqWgBoaE+uQU8JYBeP73ABELq/CFw
	 6QewEK4sURI+SkNxb+hhfWRs8CjORLVVK/UsFu3hCNuLPHN1ZfJ73ZDnodDlA8ehoyw9c
	 9vASBIPI8BbdlvcPQ9gmNhLOXgJzpiFWOY+hO5JwUi0i6F+pxkurTJrfmVXDaUZfcxwvL
	 Pvan7kkADDTDkKwsv4OivSwrsxRkLN901sT7TCCwKMzsIH4EwSMbnyL49QnHUTVuqtx6Y
	 x6S0gOryArWjrK6945R7MvDH+s0698MitzgmjduveF8Hh74iQ3R9aM1S0UxwyCHf3+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622358;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=cvTi/nNYHR2TYIOUf2vi5rClYm97tIxKBSXMmmYFqlY=;
	b=bQK8HJIZB6657UUzNMrUmsSSLrzrlgoyzpXLNfWiEp0vVdcdBQlLMcNhWp5ZO9Zo4EZD
	 j3nyx3yy96GgNTHnAx0cDXviSLW+xUWlfdHEY+2cnp9WfK2fVAJYDnDv5u4uytvWSgdM4
	 R67lR4V5oUG2oBCTEBUbEBwgDVVyRMZoekQL82Xf/0AcsOFSzzOQihf9C1v87BaNND/tf
	 3sE9lDj1r/tZCOzLg8VhIaTCavUgDiLG7BnUIhlxaBuGhgMnhmK5VZRpup6k3jzi/QNO+
	 UNLkK31yXw1wpECJaOwDgrKfDAHozSpo767DEeChK0CXrGqWklCDM0Scmh04gI+ICRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QFCsyik4;
	arc=none smtp.remote-ip=95.215.58.198
Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67429606A323
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67429606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QFCsyik4
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/XkNz3r9eFnmSbOvrGYUn0rZ+WAp3AeHIjYmS1q0RGE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795622355; v=1; x=1796227155;
 b=QFCsyik4SJM73hazO05b1WJ43qtd7xIBn14gV99k3gh4uk8shf/78xdUd7cAjveEI2WMpAyP
 svGUpdbe+ayPLHbVVP1haWfg+3zmIPyU3xBy9rt01oY03/qC0VOdCqqlYTGRtsyGazDuFQQeb8Z
 eZ2qf1bujZ+WxAcl7BG1CyRs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a8a5ba318e6399da;
	Wed, 25 Nov 2026 15:59:15 +0000
X-Mizu-Trace-ID: a8a5ba318e6399da
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so37299e87.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 07:59:14 -0800 (PST)
X-Gm-Message-State: APuU4Z/N+NFY4v0rlKmp9WaJX598Vk7C9rPaj8EoFISCl3EUeS5GV2VP
	5+3+/+7VYssQXz0/Ih9YMDwPulZC7V9v5m0LhLY8PxijKlplTZdNhSKNxeS9XZWnh3ppXK0hD5m
	6LK41kkC3aSVKzz+8wYhP4zA69327QbctE+9LjVag
X-Received: by 2002:a05:6512:10c7:b0:5bf:f84f:1d74 with SMTP id
 2adb3069b0e04-5c21a27810amr593536e87.13.1795622354030; Wed, 25 Nov 2026
 07:59:14 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261125153911.106793-1-fuad.tabba@linux.dev> <20261125153911.106793-10-fuad.tabba@linux.dev>
 <sashiko-outbox-233684@kernel.org>
In-Reply-To: <sashiko-outbox-233684@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 25 Nov 2026 15:58:37 +0000
X-Gmail-Original-Message-ID: <CA+EHjTz1SuYC9GnMRH2Fe71jxKm1QvoE5tEopBe6k_gFNdbwHQ@mail.gmail.com>
X-Gm-Features: Aa3M54qU1hrnXAD2dBM1Uj3GqNjkJxsnaGRBLC-c83EOnBK74LQNPnC0lvVf4bs
Message-ID: <CA+EHjTz1SuYC9GnMRH2Fe71jxKm1QvoE5tEopBe6k_gFNdbwHQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/20] KVM: arm64: Report an incomplete feature map
 with WARN_ON()
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Nov 2026 at 15:55, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] KVM: arm64: unused str parameter and name field in
>   check_feat_map()
[...]
> [Severity: Low]
> Does replacing kvm_err() with WARN_ON() leave the str parameter of
> check_feat_map() and struct reg_feat_map_desc::name unused?


Deliberate. The #ifdef was removed at Oliver's request [1], and the
warning doesn't print the register's name or the bits, as discussed
there. The str parameter and the name field are kept so that this
patch only changes how the check reports an incomplete feature map.

/fuad

[1] https://lore.kernel.org/all/avyZH2g3rrIVm-Fl@kernel.org/
