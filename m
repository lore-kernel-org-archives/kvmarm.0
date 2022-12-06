Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A146AB3
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 13:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD54CC433D6;
	Tue,  6 Dec 2022 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670332335;
	bh=gVn9Lg/QZwJtmmlp7lTRhA62TfLu/XHBOIJp1rZlLWk=;
	h=From:To:Cc:Subject:Date:From;
	b=eKrQQ8j58npidKyrKQVBXRAJN5JCMb/V684QV5fhkpTZLllxwYmo0lX5eUW8y/Qte
	 XMOARJ359SRMkQffF9lndvFi5cOcpdTOUvNZbIqb55DVFs3VbwcrU1Zjr7dR3jRK41
	 O/dk1TWWFtxD7mnPVZuffZ7xhClatxb71EcwUpvFujh2VUIX/fZV92KRuSzVqIB3Ha
	 Ve5lMKseSuViJxbzH7EPyohpGfbL6ivSOWM4orw0w8OiZLKpmGvjv736wAH8d3/E/b
	 FRIAMu7yixuZalqKpIHQ3olgb9g+Xoog0fyi2hxOKYhDW5quTlXmQg2aKjyLWZkR2e
	 BmbII65EF9JwQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 0/3] arm64/sysreg: ISR register conversions
Date: Tue,  6 Dec 2022 13:11:41 +0000
Message-Id: <20221206131144.115774-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=782; i=broonie@kernel.org; h=from:subject; bh=gVn9Lg/QZwJtmmlp7lTRhA62TfLu/XHBOIJp1rZlLWk=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjjz+Mki8M4tdfzZ0xpMsdaDNQHLlOlRjCRwZPPAxd dgL6SOWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY48/jAAKCRAk1otyXVSH0F9SB/ wIb1lgTKPJMz08nYHVxiWYUZ/z0a/2AjhQXe57WnJskfkFpVRcUqphjNN7ZAE1OYpG8rqIIuVsdb10 7kkMTagQAap78TzojbWYPrW/PO5AyYciBS6jGCJswmcY43++Nv/P7l0EEoRWuVBL5Twuc4HqG8SNJx /bmrgnPDWXiyMo4C82HNmbDU0RQjAuiY3eMohm58JjEQlNdabBhIm9SwzIE260f61A2NjLh2RyzpOd AQXjdxlfqfP4nruthbQ9SvgeF3eZfd7K7O4a2wcN2xqmcMomADKNmZcvbkYofBwnBcCexg/Sitpk5c lmyUaGTCjbWuCUGbVLrQCeJT6xVq9u
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

This series pulls the generated sysreg updates out of the previously
posted series for NMI support then adds an incremental patch on top of
that using the generated constant for ISR_EL1.A in the KVM entry code
suggested by Marc Zyngier.  This should hopefully help these progress
without getting tied up by the more involved NMI rework (and cut down
the size of that series if they do get merged).

Mark Brown (3):
  arm64/sysreg: Add definition for ICC_NMIAR1_EL1
  arm64/sysreg: Add definition of ISR_EL1
  KVM: arm64: Use symbolic definition for ISR_EL1.A

 arch/arm64/kvm/hyp/entry.S |  2 +-
 arch/arm64/tools/sysreg    | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.30.2

